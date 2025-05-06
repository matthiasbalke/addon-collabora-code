# Home Assistant Add-on: Collabora Online Development Edition (CODE)

This add-on allows you to run [Collabora Online Development Edition (CODE)][official-site] on your Home Assistant instance.

## Features

Configure basic settings within the add-on settings:

- set admin username and passwort
- configure a custom DNS hostname
- set `coolwsd` commandline arguments
- generate self-signed certificates for testing purposes

or fully customize the `coolwsd.xml` within the `addon_config` directory.

## Setup Add-on repository

### automatic setup

1. Click on the Home Assistant `My button` below:

   [![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.][my-ha-badge]][my-ha-url]

1. Click `Add`.
1. Click on the three dots menu in the top right.
1. Click on `Check for updates`.
1. Refresh the page.

### manual setup

1. In the Home Assistant add-on store, a possibility to add a repository is provided.
1. Use the following URL to add this repository:

```txt
https://github.com/matthiasbalke/ha-addons
```

1. Click on the three dots menu in the top right
1. Click on `Check for updates`
1. Refresh the page.

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Home Assistant add-on.

1. Add the Add-on repository to your Home Assistant, like described above.
1. In your profile activate the `advanced mode`, to be able to install `experimental`
   add-ons. Otherwise the add-on will not be shown in the add-on store.
1. Click the Home Assistant `My button` below to open the add-on on your Home
   Assistant instance.

   [![Open this add-on in your Home Assistant instance.][addon-badge]][addon]

1. Click the "Install" button to install the add-on.
1. Configure the `username` and `password` options.
1. Start the `Collabora Online Development Edition (CODE)` add-on.
1. Check the logs of the `Collabora Online Development Edition (CODE)` add-on to see
   if everything went well.

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

### Using the add-on settings

#### Option `username`

This option allows you to change the username to use when loggin in to the web admin.

```txt
https://<server-name.com>/browser/dist/admin/admin.html
```

#### Option `password`

This option allows you to change the password to use when logging in to the web admin.

```txt
https://<server-name.com>/browser/dist/admin/admin.html
```

#### Option `generate_ssl_certificate`

This option allows you to generate self-signed certificates on add-on startup.
**This options is recommended for testing purposes only.**

#### Option `server_name`

This option allows you to change the DNS name the server is running on.

**Note**: _When using a reverse proxy setup, set this to the (public) DNS name the add-on is reachable by._

#### Option `coolwsd_arguments`

This option allows you to set command line arguments, passed to the `coolwsd` binary. This can be used
to configure basic setups easily without modifying the `coolwsd.xml` in the `addons_config` directory.

See the [official docs][collabora-official-docs] for detailed explanations of possible arguments.

### Using configuration file `coolwsd.xml`

The add-on can also be configured by modifing the configuration file (`coolwsd.xml`) located in the `addon_config` directory.

See the [official docs][collabora-official-docs] for detailed explanations of possible configuration options.

**Note**: _The options specified in the add-on settings overwrite the configuration in the XML file!_

## Support

Got questions?

Feel free to [open an issue here][issue] on GitHub.

## Authors & contributors

The original setup of this repository is by [Matthias Balke][matthiasbalke].

For a full list of all authors and contributors, check [the contributor's page][contributors].

# MIT License

Copyright (c) 2025 Matthias Balke

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[official-site]: https://www.collaboraonline.com/de/code/
[my-ha-badge]: https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg
[my-ha-url]: https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fmatthiasbalke%2Fha-addons
[addon-badge]: https://my.home-assistant.io/badges/supervisor_addon.svg
[addon]: https://my.home-assistant.io/redirect/supervisor_addon/?addon=d8ac6820_collabora-code&repository_url=https%3A%2F%2Fgithub.com%2Fmatthiasbalke%2Fha-addons
[collabora-official-docs]: https://sdk.collaboraonline.com/docs/installation/Configuration.html
[issue]: https://github.com/matthiasbalke/addon-collabora-code/issues
[matthiasbalke]: https://github.com/matthiasbalke
[contributors]: https://github.com/matthiasbalke/addon-collabora-code/graphs/contributors
