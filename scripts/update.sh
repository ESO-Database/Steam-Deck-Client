#!/bin/bash

source /home/deck/Applications/ESO-Database/config/config.sh
source /home/deck/Applications/ESO-Database/scripts/tools/functions.sh


RELEASE_JSON=$(curl --location --silent ${ESODB_GITHUB_URL})
REMOTE_VERSION="$(echo "${RELEASE_JSON}" | jq --raw-output '.tag_name')"
LOCAL_VERSION=$(cat /home/deck/Applications/ESO-Database/version.txt | xargs) # xargs trims the string
DOWNLOAD_URL="$(echo "${RELEASE_JSON}" | jq -r '.assets[].browser_download_url')"
UPDATE_TEMP_DIR="/tmp/esodb_client_update"
ESODB_DESKTOP_APPLICATION_PATH="/home/deck/.local/share/applications"
ESODB_APPLICATION_PATH="/home/deck/Applications/ESO-Database"


desktop_file_call="false"

while getopts 'd' flag; do
  case "${flag}" in
    d) desktop_file_call='true' ;;
    *) echo "Unknown flag" ;;
  esac
done


if [ ! "${LOCAL_VERSION}" = "${REMOTE_VERSION}" ]; then

	print_status "Downloading new version ${REMOTE_VERSION}"

	# Ensure the temp directory is empty
	if [ -d "${UPDATE_TEMP_DIR}" ]; then
		rm -fr "${UPDATE_TEMP_DIR}"
	fi

	mkdir -p "${UPDATE_TEMP_DIR}"

	print_status "Downloading ESO-Database Steam Deck Client files..."
  echo "${DOWNLOAD_URL}"
  curl --progress-bar --location "${DOWNLOAD_URL}" -o "${UPDATE_TEMP_DIR}/core.zip"
  print_success "Done"

  print_status "Extracting files..."
  old_pwd=$(pwd)
  cd "${UPDATE_TEMP_DIR}"
  unzip -qq -o "${UPDATE_TEMP_DIR}/core.zip"
  rm -f "${UPDATE_TEMP_DIR}/core.zip"
  cd "${old_pwd}"
  print_success "Done"


	print_status "Applying update files..."
	rsync --exclude="user.config.sh" --recursive --delete --human-readable "${UPDATE_TEMP_DIR}/" "${ESODB_APPLICATION_PATH}"
	print_success "Done"


	print_status "Cleanup temp directory..."
	rm -fr "${UPDATE_TEMP_DIR}"
	print_success "Done"


  print_status "Set script permissions..."
  chmod +x "${ESODB_APPLICATION_PATH}/scripts/"*.sh
  print_success "Done"


  print_status "Updating Elder Scrolls Online AddOns..."
  eval "${ESODB_APPLICATION_PATH}/scripts/update-addons.sh"
  print_success "Done"


  print_status "Updating background services"
  cp -f "${ESODB_APPLICATION_PATH}/install/systemd/eso-database-uploader.service" /home/deck/.config/systemd/user/eso-database-uploader.service
  cp -f "${ESODB_APPLICATION_PATH}/install/systemd/eso-database-updater.service" /home/deck/.config/systemd/user/eso-database-updater.service
	cp -f "${ESODB_APPLICATION_PATH}/install/systemd/eso-database-updater.timer" /home/deck/.config/systemd/user/eso-database-updater.timer
  cp -f "${ESODB_APPLICATION_PATH}/install/systemd/eso-database-addon-updater.service" /home/deck/.config/systemd/user/eso-database-addon-updater.service
  cp -f "${ESODB_APPLICATION_PATH}/install/systemd/eso-database-addon-updater.timer" /home/deck/.config/systemd/user/eso-database-addon-updater.timer

  systemctl --user daemon-reload
  systemctl --user try-restart eso-database-uploader.service
  systemctl --user try-restart eso-database-updater.timer
  systemctl --user try-restart eso-database-addon-updater.timer


	print_status "Updating Launcher entries"
	rm -f $(ls -d ${ESODB_DESKTOP_APPLICATION_PATH}/ESODB-Client-*)
  cp -f "${ESODB_APPLICATION_PATH}/install/desktop/"* "${ESODB_DESKTOP_APPLICATION_PATH}"
  chmod 755 "${ESODB_DESKTOP_APPLICATION_PATH}/ESODB-Client-"*
  print_success "Done"


	print_status "Remove remaining setup files..."
  rm -fr "${ESODB_APPLICATION_PATH}/install"
  print_success "Done"


	print_success "The update to version ${REMOTE_VERSION} has been successfully performed!"
else
	print_status "You have the latest version installed! (Version ${LOCAL_VERSION})"
fi

if [ "${desktop_file_call}" == "true" ]; then
	sleep 5
fi
