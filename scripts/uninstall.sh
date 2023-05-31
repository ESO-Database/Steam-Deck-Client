#!/bin/bash

source /home/deck/Applications/ESO-Database/config/config.sh
source /home/deck/Applications/ESO-Database/scripts/tools/functions.sh

ESODB_DESKTOP_APPLICATION_PATH="/home/deck/.local/share/applications"

print_info () {
  echo -e "\033[1m$1\033[0m"
}

print_banner "\n-----------------------------------------------------------------"
print_banner " This script will uninstall the ESO-Database SteamDeck Client"
print_banner "-----------------------------------------------------------------"

read -p "$(echo -e "\033[1mDo you really want to uninstall the ESO-Database Client? (y/n)\033[0m") " yn

case $yn in
	[yY] ) echo -e ""

		read -p "Do you want your personal settings to be deleted as well? (y/n) " yn
		case $yn in
			[yY] ) print_info "Removing personal settings..."
				if [ -d "${ESODB_APP_DATA_PATH}" ]; then
					rm -fr "${ESODB_APP_DATA_PATH}"
				fi
				print_success "Done"
		esac

		echo -e "\n"


		print_info "Uninstalling background services"
		systemctl --user stop eso-database-uploader.service
    systemctl --user disable eso-database-uploader.service
    rm -f /home/deck/.config/systemd/user/eso-database-uploader.service

		systemctl --user stop eso-database-updater.timer
		systemctl --user disable eso-database-updater.timer
		rm -f /home/deck/.config/systemd/user/eso-database-updater.service
		rm -f /home/deck/.config/systemd/user/eso-database-updater.timer

    systemctl --user stop eso-database-addon-updater.timer
    systemctl --user disable eso-database-addon-updater.timer
    rm -f /home/deck/.config/systemd/user/eso-database-addon-updater.service
    rm -f /home/deck/.config/systemd/user/eso-database-addon-updater.timer

		systemctl --user daemon-reload

		print_success "Done"


		print_info "Removing AddOns..."
		rm -fr "${ESODB_ESO_PROTON_ADDONS_LIVE_PATH}/ESODatabaseExport"
		rm -fr "${ESODB_ESO_PROTON_ADDONS_LIVE_PATH}/ESODatabaseGameDataExport"
		rm -fr "${ESODB_ESO_PROTON_ADDONS_LIVE_PATH}/ESODatabaseLeaderboardExport"

		rm -fr "${ESODB_ESO_PROTON_SV_PATH}/ESODatabaseExport.lua"
		rm -fr "${ESODB_ESO_PROTON_SV_PATH}/ESODatabaseGameDataExport.lua"
		rm -fr "${ESODB_ESO_PROTON_SV_PATH}/ESODatabaseLeaderboardExport.lua"

		print_success "Done"


		print_info "Removing Desktop shortcuts..."
		rm -f $(ls -d ${ESODB_DESKTOP_APPLICATION_PATH}/ESODB-Client-*)
		print_success "Done\n"


		print_info "Removing application folder..."
		rm -fr /home/deck/Applications/ESO-Database
		print_success "Done"


		print_banner "\n-------------------------------------------------------------------------------------------"
    print_banner " The uninstallation of the ESO-Database SteamDeck client has been successfully completed!"
    print_banner "-------------------------------------------------------------------------------------------"

		exit;;
	[nN] ) echo "Aborting, no change has been made.";
		exit;;
	* ) echo "Invalid response, aborting.";
		exit;;
esac
