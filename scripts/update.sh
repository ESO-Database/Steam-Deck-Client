#!/bin/bash

source /home/deck/Applications/ESO-Database/config/config.sh
source /home/deck/Applications/ESO-Database/scripts/tools/functions.sh


UPDATE_TEMP_DIR=/tmp/esodb_client_update
ESODB_DESKTOP_APPLICATION_PATH="/home/deck/.local/share/applications"
RELEASE_JSON=$(curl --location --silent ${ESODB_GITHUB_URL})
REMOTE_VERSION="$(echo "${RELEASE_JSON}" | jq --raw-output '.tag_name')"
LOCAL_VERSION=$(cat /home/deck/Applications/ESO-Database/version.txt)
DOWNLOAD_URL="$(echo "${RELEASE_JSON}" | jq -r '.assets[].browser_download_url')"

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
	rsync --exclude="user.config.sh" --recursive --delete --human-readable "${UPDATE_TEMP_DIR}/" /home/deck/Applications/ESO-Database
	print_success "Done"


	print_status "Cleanup temp directory..."
	rm -fr "${UPDATE_TEMP_DIR}"
	print_success "Done"


  print_status "Set script permissions..."
  chmod +x /home/deck/Applications/ESO-Database/scripts/*.sh
  print_success "Done"


	# TODO: Check if this step is required for the update-addons.sh script

  print_status "Fetching Elder Scrolls Online AddOns meta data..."
  fetch_addons_result=$(/home/deck/Applications/ESO-Database/scripts/api/get-addons.sh)
  if [ "${fetch_addons_result}" = "ok" ]; then
  	print_success "OK"
  else
  	print_error "Could not get AddOns meta information!"
  fi


  print_status "Updating Elder Scrolls Online AddOns..."
  /home/deck/Applications/ESO-Database/scripts/update-addons.sh
  print_success "Done"


  print_status "Superuser installation steps"
  print_info_warning "Superuser privileges are required for the following installation steps.\nIf you do not have a superuser password set up on your Steam deck, please read the instructions:\n\nhttps://www.eso-database.com/steam-deck-setup"


  print_status "Updating background services"
  sudo cp -f /home/deck/Applications/ESO-Database/install/systemd/eso-database-uploader.service /etc/systemd/system/eso-database-uploader.service
  sudo cp -f /home/deck/Applications/ESO-Database/install/systemd/eso-database-addon-updater.service /etc/systemd/system/eso-database-addon-updater.service
  sudo cp -f /home/deck/Applications/ESO-Database/install/systemd/eso-database-addon-updater.timer /etc/systemd/system/eso-database-addon-updater.timer

  sudo systemctl daemon-reload
  sudo systemctl try-restart eso-database-uploader.service
  sudo systemctl try-restart eso-database-addon-updater.timer


	print_status "Updating Launcher entries"
	rm -f $(ls -d ${ESODB_DESKTOP_APPLICATION_PATH}/ESODB-Client-*)
  cp -f /home/deck/Applications/ESO-Database/install/desktop/* "${ESODB_DESKTOP_APPLICATION_PATH}"
  print_success "Done"


	print_status "Remove remaining setup files..."
  rm -fr /home/deck/Applications/ESO-Database/install
  print_success "Done"


	print_success "The update to version ${REMOTE_VERSION} has been successfully performed!"
else
	print_status "You have the latest version installed!"
fi
