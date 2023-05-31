#!/bin/bash

set -eo pipefail

ESODB_GITHUB_URL="https://api.github.com/repos/ESO-Database/Steam-Deck-Client/releases/latest"
ESODB_URL="$(curl --location --silent ${ESODB_GITHUB_URL} | grep -E 'browser_download_url.*zip' | cut -d '"' -f 4)"
ESODB_DESKTOP_APPLICATION_PATH="/home/deck/.local/share/applications"
ESODB_APPLICATION_PATH="/home/deck/Applications/ESO-Database"

report_error() {
	FAILURE="$(caller): ${BASH_COMMAND}"
	print_error "${FAILURE}"
}
print_error () {
  echo -e "\n"
  echo -e "\033[1;31m-----------------------\033[0m\n"
	echo -e "\033[1;31m------   ERROR   ------\033[0m\n"
	echo -e "\033[1;31m-----------------------\033[0m\n"
	echo -e "\033[0;31m$1\033[0m\n"
	sleep 20
}
print_status () {
  echo -e "\033[1;32m# $1\033[0m"
}
print_info () {
  echo -e "\033[0m$1\033[0m\n"
}
print_info_warning () {
	echo -e "\033[0;33m$1\033[0m\n"
}
print_success () {
	echo -e "\033[1;36m=> $1\033[0m\n"
}
print_banner () {
	echo -e "\033[1;36m$1\033[0m\n"
}

trap report_error ERR


print_banner "\n-------------------------------------------------------------"
print_banner " This script will install the ESO-Database SteamDeck Client"
print_banner "-------------------------------------------------------------"


print_status "Creating required directories..."
mkdir -p "${ESODB_APPLICATION_PATH}"
mkdir -p /home/deck/.eso-database-client
mkdir -p /home/deck/.eso-database-client/meta
print_success "Done"


print_status "Downloading ESO-Database Steam Deck Client files..."
echo "${ESODB_URL}"
curl --progress-bar --location "${ESODB_URL}" -o "${ESODB_APPLICATION_PATH}/core.zip"
print_success "Done"

print_status "Extracting files..."
cd "${ESODB_APPLICATION_PATH}"
unzip -qq -o "${ESODB_APPLICATION_PATH}/core.zip"
rm -f "${ESODB_APPLICATION_PATH}/core.zip"
print_success "Done"

print_status "Set script permissions..."
chmod +x "${ESODB_APPLICATION_PATH}/scripts/"*.sh
print_success "Done"


print_status "ESO-Database Account login"
login_status=$("${ESODB_APPLICATION_PATH}/scripts/api/get-auth-status.sh")
if [ "${login_status}" = "false" ]; then
	print_info "Please login in with your ESO-Database account..."
	sleep 2
	eval "${ESODB_APPLICATION_PATH}/scripts/login.sh"
	print_success "Done"
else
	user_name=$("${ESODB_APPLICATION_PATH}/scripts/tools/get-user-name.sh")
	print_info "Already signed in as \033[1;34m${user_name}\033[0m Skipping login step."
	print_success "Done"
fi


print_status "Installing Elder Scrolls Online AddOns..."
eval "${ESODB_APPLICATION_PATH}/scripts/update-addons.sh"
print_success "Done"


print_status "Install background services"
cp -f "${ESODB_APPLICATION_PATH}/install/systemd/eso-database-uploader.service" /home/deck/.config/systemd/user/eso-database-uploader.service
cp -f "${ESODB_APPLICATION_PATH}/install/systemd/eso-database-updater.service" /home/deck/.config/systemd/user/eso-database-updater.service
cp -f "${ESODB_APPLICATION_PATH}/install/systemd/eso-database-updater.timer" /home/deck/.config/systemd/user/eso-database-updater.timer
cp -f "${ESODB_APPLICATION_PATH}/install/systemd/eso-database-addon-updater.service" /home/deck/.config/systemd/user/eso-database-addon-updater.service
cp -f "${ESODB_APPLICATION_PATH}/install/systemd/eso-database-addon-updater.timer" /home/deck/.config/systemd/user/eso-database-addon-updater.timer
print_success "Done"


print_status "Enable and start background services"
eval "${ESODB_APPLICATION_PATH}/scripts/enable-auto-upload.sh"
eval "${ESODB_APPLICATION_PATH}/scripts/enable-auto-update.sh"
eval "${ESODB_APPLICATION_PATH}/scripts/enable-addon-auto-update.sh"
print_success "Done"


print_status "Creating Launcher entries"
cp -f "${ESODB_APPLICATION_PATH}/install/desktop/"* "${ESODB_DESKTOP_APPLICATION_PATH}"
print_success "Done"


print_status "Remove remaining setup files..."
rm -fr "${ESODB_APPLICATION_PATH}/install"
print_success "Done"


# Remove the install Desktop icon
if [ -f /home/deck/Desktop/ESO-Database.desktop ]; then
	rm -f /home/deck/Desktop/ESO-Database.desktop
fi


print_banner "\n-------------------------------------------------------------------------------------------"
print_banner " The installation of the ESO-Database SteamDeck client has been completed successfully."
print_banner " You can now start The Elder Scrolls Online, following a game session your data\n will be transferred automatically in the background."
print_banner "-------------------------------------------------------------------------------------------"

echo -e "This window will be closed in 20 seconds...\n"


setsid xdg-open "https://www.eso-database.com/steam-deck-installation-complete/" >/dev/null 2>&1
sleep 20
