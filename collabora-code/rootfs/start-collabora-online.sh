#!/usr/bin/env bashio
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# migrate 0.1.0 configuration to 0.2.0
if bashio::config.exists 'dont_gen_ssl_cert' || bashio::config.exists 'extra_params'; then
    bashio::log.info "Updating Configuration ..."

    # remove "dont_gen_ssl_cert"
    if bashio::config.exists 'dont_gen_ssl_cert'; then
        bashio::addon.option 'dont_gen_ssl_cert'
    fi

    # remove "extra_params"
    if bashio::config.exists 'extra_params'; then
        bashio::addon.option 'extra_params'
    fi

    bashio::log.info "done."
    bashio::log.info ""
fi

# ensure config directory is readable by process user
# this is needed, as after editing coolwsd.xml using smb, the owner is set to root
chown -R cool:cool /config

# expose coolwsd.xml in addon config directory
if ! bashio::fs.file_exists "/config/coolwsd.xml"; then
    cp -a /etc/coolwsd/coolwsd.xml /config/coolwsd.xml \
        || bashio::exit.nok \
            'Failed creating "/config/coolwsd.xml"'
fi

# ensure config is readable by process user
# this is needed, as after editing coolwsd.xml using smb, the owner is set to root
chown -R cool:cool /config

# generate WOPI proof key
if ! bashio::fs.file_exists "/config/proof_key"; then
    bashio::log.info "Generating WOPI proof key (/config/proof_key) ..."
    sudo -H -u cool bash -c 'ssh-keygen -t rsa -N "" -m PEM -f /config/proof_key' \
        || bashio::exit.nok \
            'Failed creating WOPI proof key "/config/proof_key"'
    # until changing the configuration dir is fixed
    # symlink proof_key into default config directory
    sudo -H -u cool bash -c 'ln -s /config/proof_key /etc/coolwsd/proof_key' \
        || bashio::exit.nok \
            'Failed creating symlink for proof key "/etc/coolwsd/proof_key -> /config/proof_key"'
fi

bashio::log.info "Starting Collabora CODE Edition ..."

# get HA addon config
if bashio::config.has_value 'username'; then
    USERNAME=$(bashio::config 'username')
else
    bashio::log.error "\"username\" not set. Please set \"username\" in add-on config. Aborting."
    exit 1;
fi
if bashio::config.has_value 'password'; then
    PASSWORD=$(bashio::config 'password')
else
    bashio::log.error "\"password\" not set. Please set \"password\" in add-on config. Aborting."
    exit 1;
fi
if bashio::config.has_value 'server_name'; then
    SERVER_NAME=$(bashio::config 'server_name')
else
    SERVER_NAME=""
fi
if bashio::config.true 'generate_ssl_certificate'; then
    unset DONT_GEN_SSL_CERT
else
    DONT_GEN_SSL_CERT=true
fi
if bashio::config.has_value 'coolwsd_arguments'; then
    extra_params=$(bashio::config 'coolwsd_arguments')
else
    extra_params=""
fi

if bashio::var.has_value "${SERVER_NAME}"; then
    bashio::log.info "setting server name to: \"${SERVER_NAME}\""
fi

if test "${DONT_GEN_SSL_CERT-set}" = set; then
bashio::log.info "Generating new self-signed certificates..."
# Generate new SSL certificate instead of using the default
mkdir -p /tmp/ssl/
cd /tmp/ssl/ || exit
mkdir -p certs/ca
bashio::log.info "Generating new CA..."
openssl genrsa -out certs/ca/root.key.pem 2048

openssl req -x509 -new -nodes -key certs/ca/root.key.pem -days 9131 -out certs/ca/root.crt.pem -subj "/C=DE/ST=BW/L=Stuttgart/O=Dummy Authority/CN=Dummy Authority"
mkdir -p certs/servers
mkdir -p certs/tmp
mkdir -p certs/servers/localhost
openssl genrsa -out certs/servers/localhost/privkey.pem 2048
if test "${cert_domain-set}" = set; then
openssl req -key certs/servers/localhost/privkey.pem -new -sha256 -out certs/tmp/localhost.csr.pem -subj "/C=DE/ST=BW/L=Stuttgart/O=Dummy Authority/CN=localhost"
else
openssl req -key certs/servers/localhost/privkey.pem -new -sha256 -out certs/tmp/localhost.csr.pem -subj "/C=DE/ST=BW/L=Stuttgart/O=Dummy Authority/CN=${cert_domain}"
fi
openssl x509 -req -in certs/tmp/localhost.csr.pem -CA certs/ca/root.crt.pem -CAkey certs/ca/root.key.pem -CAcreateserial -out certs/servers/localhost/cert.pem -days 9131
cert_params="\
 --o:ssl.cert_file_path=/tmp/ssl/certs/servers/localhost/cert.pem \
 --o:ssl.key_file_path=/tmp/ssl/certs/servers/localhost/privkey.pem \
 --o:ssl.ca_file_path=/tmp/ssl/certs/ca/root.crt.pem"

chown cool:cool -R /tmp/ssl/certs
fi

# store HA configured username and password (salted)
bashio::log.info "Storing coolwsd username \"${USERNAME}\" and password..."
sudo -H -u cool bash -c "coolconfig --config-file /config/coolwsd.xml set-admin-password --user '${USERNAME}' --password '${PASSWORD}'"
bashio::log.info "done."

# Start coolwsd
bashio::log.info "Starting coolwsd..."
# explicitly allow spaces to separate arguments
# shellcheck disable=SC2086
sudo -H -u cool bash -c "exec /usr/bin/coolwsd --version --use-env-vars --config-dir /config --config-file /config/coolwsd.xml ${cert_params:-} --o:sys_template_path=/opt/cool/systemplate --o:child_root_path=/opt/cool/child-roots --o:file_server_root_path=/usr/share/coolwsd --o:cache_files.path=/opt/cool/cache --o:stop_on_config_change=true ${extra_params:-}"
