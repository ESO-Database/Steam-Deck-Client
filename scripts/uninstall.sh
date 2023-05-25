#!/bin/bash

source /home/deck/Applications/ESO-Database/config/config.sh
source /home/deck/Applications/ESO-Database/scripts/tools/functions.sh

ESODB_DESKTOP_APPLICATION_PATH="/home/deck/.local/share/applications"

print_info () {
  printf "\033[1m$1\033[0m"
}


read -p "Do you really want to uninstall the ESO-Database Client? (y/n) " yn

case $yn in
	[yY] ) echo -e ""

		read -p "Do you want your personal settings to be deleted as well? (y/n) " yn
		case $yn in
			[yY] ) print_info "Removing personal settings..."
				rm -fr /home/deck/.eso-database-client
				print_success "Done\n"
		esac


		#print_info "Superuser installation steps\n"
    #print_info_warning "Superuser privileges are required for the following uninstall steps.\nIf you do not have a superuser password set up on your Steam deck, please read the instructions:\n\nhttps://www.eso-database.com/steam-deck-setup\n\n "

		print_info "Uninstalling background services\n"
    #sudo systemctl stop eso-database-uploader.service
    #sudo systemctl disable eso-database-uploader.service
		#sudo rm -f /etc/systemd/system/eso-database-uploader.service
		systemctl --user stop eso-database-uploader.service
    systemctl --user disable eso-database-uploader.service
    rm -f /home/deck/.config/systemd/user/eso-database-uploader.service

    #sudo systemctl stop eso-database-addon-updater.timer
    #sudo systemctl disable eso-database-addon-updater.timer
    #sudo rm -f /etc/systemd/system/eso-database-addon-updater.service
    #sudo rm -f /etc/systemd/system/eso-database-addon-updater.timer
    systemctl --user stop eso-database-addon-updater.timer
    systemctl --user disable eso-database-addon-updater.timer
    rm -f /home/deck/.config/systemd/user/eso-database-addon-updater.service
    rm -f /home/deck/.config/systemd/user/eso-database-addon-updater.timer

		#sudo systemctl daemon-reload
		systemctl --user daemon-reload

		print_success "Done\n"


		print_info "Removing AddOns..."
		rm -fr "${ESODB_ESO_PROTON_ADDONS_LIVE_PATH}/ESODatabaseExport"
		rm -fr "${ESODB_ESO_PROTON_ADDONS_LIVE_PATH}/ESODatabaseGameDataExport"
		rm -fr "${ESODB_ESO_PROTON_ADDONS_LIVE_PATH}/ESODatabaseLeaderboardExport"

		rm -fr "${ESODB_ESO_PROTON_SV_PATH}/ESODatabaseExport.lua"
		rm -fr "${ESODB_ESO_PROTON_SV_PATH}/ESODatabaseGameDataExport.lua"
		rm -fr "${ESODB_ESO_PROTON_SV_PATH}/ESODatabaseLeaderboardExport.lua"

		print_success "Done\n"


		print_info "Removing Desktop shortcuts..."
		rm -f $(ls -d ${ESODB_DESKTOP_APPLICATION_PATH}/ESODB-Client-*)
		print_success "Done\n\n"


		print_info "Removing application folder..."
		rm -fr /home/deck/Applications/ESO-Database
		print_success "Done\n"


		print_success "The uninstallation of the ESO Database Client has been completed successfully!"

		exit;;
	[nN] ) echo "Aborting, no change has been made.";
		exit;;
	* ) echo "Invalid response, aborting.";
		exit;;
esac
