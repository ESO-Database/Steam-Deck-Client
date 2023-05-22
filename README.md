# ESO-Database Steam Deck Client
[![Build release package](https://github.com/ESO-Database/Steam-Deck-Client/actions/workflows/release.yml/badge.svg?branch=master)](https://github.com/ESO-Database/Steam-Deck-Client/actions/workflows/release.yml)
[![GitHub issues](https://img.shields.io/github/issues/ESO-Database/Steam-Deck-Client?logo=github)](https://github.com/ESO-Database/Steam-Deck-Client/issues)
[![Discord](https://img.shields.io/discord/683990734831091723?logo=discord)](https://discord.gg/WTv3a8bHEB)
<img src="https://static.eso-database.com/github/steam-deck/steam-deck-eso.png?1">

With the ESO-Database Steam Deck Client you update the needed The Elder Scrolls Online AddOns and automatically upload the AddOn data after your game sessions with a background service.

You have to setup a superuser password in order to enable automatic uploads. For more information, see the <a href="#requirements">requirements</a> section.

## Requirements
First, head into Desktop mode if you haven’t already. To do so, go to Power, then Desktop mode in the Steam button menu. Once loaded in, enter the menu on the taskbar and find Terminal. This will load up a terminal page.

Now, all you have to do is type `passwd`

After that, you will be prompted to choose and repeat the password. Once this is done, you can proceed to the <a href="#installation">Installation</a> section.

## Installation
Right-click on the following link and select "Save Link As" and save the file to your Steam deck in desktop mode.  
<a href="https://raw.githubusercontent.com/ESO-Database/Steam-Deck-Client/master/Install-ESO-Database.desktop?token=GHSAT0AAAAAACBIEXY6FOUEQCEQL6OJ5ZBCZBZMI7Q">👉 Save this link to your Steam Deck in Desktop Mode!</a>  

After that, simply open the shortcut to start the installation of ESO Database Steam Deck Integration.

## Advanced usage
The ESO-Database Steam Deck Integrations comes with some scripts to manage the installation. There are also some shortcuts available in the launcher, search for "ESO-Database" to find them.  
  
Below you can find a table with all scripts and their available parameters.  
  
Open a terminal and navigate to the following path:
`/home/deck/Applications/ESO-Database/scripts`
  
#### List of all available scripts
The following scripts can be used to manage the ESO-Database integration.

| Script                 | Description                                                                                                                                                                                  |
|------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| disable-autoupload.sh  | Disables the auto upload service that is running in the background. The superuser password is required to execute this script.                                                               |
| enable-autoupload.sh   | Enables the auto upload service that is running in the background. The superuser password is required to execute this script.                                                                |
| login.sh               | Opens the ESO-Database.com authentication website to log in with your ESO-Database user account. The credentials are stored, you don't need this script every time you start the Steam Deck. |
| logout.sh              | Deletes the stored credentials if you have logged in with an ESO-Database user account before.                                                                                               |
| update.sh              | Checks for a new release of the ESO-Database Steam Deck integration. If an update is available, the update is executed.                                                                      |
| update-addons.sh       | Fetches all available ESO-Database AddOns and downloads the latest version of each AddOn.                                                                                                    |
| upload-addon-data.sh   | If you have disabled the auto upload service or want to upload your data manually, you can run this script to upload the exported data.                                                      |

