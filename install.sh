#!/bin/bash

set -eo pipefail

#ESODB_GITHUB_URL="https://api.github.com/repos/ESO-Database/Steam-Deck-Client/releases/latest"
#ESODB_URL="$(curl --location --silent ${ESODB_GITHUB_URL} | grep -E 'browser_download_url.*zip' | cut -d '"' -f 4)"
ESODB_DESKTOP_APPLICATION_PATH="/home/deck/.local/share/applications"

# TODO: Workaround because we currently have no release available for development
ESODB_URL="https://download.eso-database.com/steam-deck/eso-database-steam-deck.zip"


report_error() {
    FAILURE="$(caller): ${BASH_COMMAND}"
    print_error "${FAILURE}"
}
print_error () {
  printf "\n"
  printf "\033[1;31m-----------------------\033[0m\n"
	printf "\033[1;31m------   ERROR   ------\033[0m\n"
	printf "\033[1;31m-----------------------\033[0m\n"
	printf "\033[0;31m$1\033[0m\n"
	sleep 20
}
print_status () {
  printf "\n\033[1;32m# $1\033[0m\n"
}
print_info () {
  printf "\033[0m$1\033[0m\n\n"
}
print_info_warning () {
	printf "\033[0;33m$1\033[0m\n"
}
print_success () {
	printf "\033[1;36m-> $1\033[0m\n"
}

trap report_error ERR


print_status "Creating required directories..."
mkdir -p /home/deck/Applications/ESO-Database
mkdir -p /home/deck/.eso-database-client
mkdir -p /home/deck/.eso-database-client/meta


print_status "Downloading ESO-Database Steam Deck Client files..."
echo "${ESODB_URL}"
curl --progress-bar --location "${ESODB_URL}" -o /home/deck/Applications/ESO-Database/core.zip

print_status "Extracting files..."
cd /home/deck/Applications/ESO-Database
unzip -qq -o /home/deck/Applications/ESO-Database/core.zip
rm -f /home/deck/Applications/ESO-Database/core.zip

print_status "Set script permissions..."
chmod +x /home/deck/Applications/ESO-Database/scripts/*.sh
print_success "Done"


print_status "Fetching Elder Scrolls Online AddOns meta data..."
fetch_addons_result=$(/home/deck/Applications/ESO-Database/scripts/api/get-addons.sh)
if [ "${fetch_addons_result}" = "ok" ]; then
	print_success "OK"
else
	print_error "Could not get AddOns meta information!"
fi


print_status "Installing Elder Scrolls Online AddOns..."
/home/deck/Applications/ESO-Database/scripts/update-addons.sh
print_success "Done"


print_status "ESO-Database Account login"
login_status=$(/home/deck/Applications/ESO-Database/scripts/api/get-auth-status.sh)
if [ "${login_status}" = "false" ]; then
	print_info "Please login in with your ESO-Database account..."
	sleep 2
	/home/deck/Applications/ESO-Database/scripts/login.sh
else
	user_name=$(/home/deck/Applications/ESO-Database/scripts/tools/get-user-name.sh)
	print_info "Already signed in as \033[1;34m${user_name}\033[0m Skipping login step."
fi

print_status "Superuser installation steps"
print_info_warning "Superuser privileges are required for the following installation steps.\nIf you do not have a superuser password set up on your Steam deck, please read the instructions:\n\nhttps://www.eso-database.com/steam-deck-setup"


print_status "Install background services"
sudo cp -f /home/deck/Applications/ESO-Database/install/systemd/eso-database-uploader.service /etc/systemd/system/eso-database-uploader.service
sudo cp -f /home/deck/Applications/ESO-Database/install/systemd/eso-database-addon-updater.service /etc/systemd/system/eso-database-addon-updater.service
sudo cp -f /home/deck/Applications/ESO-Database/install/systemd/eso-database-addon-updater.timer /etc/systemd/system/eso-database-addon-updater.timer


print_status "Enable and start background services"
/home/deck/Applications/ESO-Database/scripts/enable-autoupload.sh
/home/deck/Applications/ESO-Database/scripts/enable-addon-autoupdate.sh


print_status "Creating Launcher entries"
cp -f /home/deck/Applications/ESO-Database/install/desktop/* "${ESODB_DESKTOP_APPLICATION_PATH}"
print_success "Done"


print_status "Remove remaining setup files..."
rm -fr /home/deck/Applications/ESO-Database/install
print_success "Done"


echo "The installation is complete!"
echo "This window will be closed in 20 seconds..."


setsid xdg-open "https://www.eso-database.com/steam-deck-installation-complete/" >/dev/null 2>&1
sleep 20

# TODO: Try to remove installation desktop shortcut
