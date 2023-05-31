# ESO-Database Steam Deck Client
[![Build release package](https://github.com/ESO-Database/Steam-Deck-Client/actions/workflows/release.yml/badge.svg)](https://github.com/ESO-Database/Steam-Deck-Client/actions/workflows/release.yml)
[![GitHub issues](https://img.shields.io/github/issues/ESO-Database/Steam-Deck-Client?logo=github)](https://github.com/ESO-Database/Steam-Deck-Client/issues)
[![Discord](https://img.shields.io/discord/683990734831091723?logo=discord)](https://discord.gg/WTv3a8bHEB)
<img src="https://static.eso-database.com/github/steam-deck/steam-deck-eso.png?1">

With ESO-Database Steam Deck Client you update the required The Elder Scrolls Online AddOns. The AddOn data will be transferred automatically after the game session.

## Installation
Right-click on the following link and select "Save Link As" and save the file to your Steam deck in desktop mode.  
<a href="https://raw.githubusercontent.com/ESO-Database/Steam-Deck-Client/master/ESO-Database.desktop">👉 Save this link to your Steam Deck in Desktop Mode!</a>  

After that, simply open the shortcut to start the installation of ESO-Database Steam Deck Integration.

## Advanced usage
The ESO-Database Steam Deck Integrations comes with some scripts to manage the installation. There are also some shortcuts available in the launcher, search for "ESO-Database" to find them.  
  
Below you can find a table with all scripts and their available parameters.  
  
Open a terminal and navigate to the following path:
`/home/deck/Applications/ESO-Database/scripts`
  
#### List of all available scripts
The following scripts can be used to manage the ESO-Database integration.

| Script                       | Description                                                                                                                                                                                  |
|:-----------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| disable-auto-upload.sh       | Disables the auto upload service that is running in the background.                                                                                                                          |
| enable-auto-upload.sh        | Enables the auto upload service that is running in the background.                                                                                                                           |
| disable-auto-update.sh       | Disables the auto Client update service that is running in the background.                                                                                                                   |
| enable-auto-update.sh        | Enables the auto Client update service that is running in the background.                                                                                                                    |
| disable-addon-auto-update.sh | Disables the auto AddOn update service that is running in the background.                                                                                                                    |
| enable-addon-auto-update.sh  | Enables the auto AddOn update service that is running in the background.                                                                                                                     |
| login.sh                     | Opens the ESO-Database.com authentication website to log in with your ESO-Database user account. The credentials are stored, you don't need this script every time you start the Steam Deck. |
| logout.sh                    | Deletes the stored credentials if you have logged in with an ESO-Database user account before.                                                                                               |
| uninstall.sh                 | This will completely uninstall the ESO-Database Client from your Steam Deck.                                                                                                                 |
| update.sh                    | Checks for a new release of the ESO-Database Steam Deck integration. If an update is available, the update is executed.                                                                      |
| update-addons.sh             | Fetches all available ESO-Database AddOns and downloads the latest version of each AddOn.                                                                                                    |
| upload-addon-data.sh         | If you have disabled the auto upload service or want to upload your data manually, you can run this script to upload the exported data.                                                      |


## How does it work?
The codebase of the ESO-Database Steam Deck client is completely written in Bash. It uses the Systemd management service on user level to execute the add-on updates, uploads as well as client updates in the background even in gaming mode.

Since there is no GUI, the integration is almost not noticeable in the game performance or battery life.

The Systemd-Uploader services watch the file change times of the SavedVariable files. When a file change is detected, the file upload is started.


## How to report a problem?
You can report problems or suggestions on the [Issues](https://github.com/ESO-Database/Steam-Deck-Client/issues) page. Alternatively, the [contact form](https://www.eso-database.com/en/contact/) on ESO-Database.com can be used.
