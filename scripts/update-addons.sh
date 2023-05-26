#!/bin/bash

source /home/deck/Applications/ESO-Database/config/config.sh
source /home/deck/Applications/ESO-Database/scripts/tools/functions.sh


desktop_file_call="false"

while getopts 'd' flag; do
  case "${flag}" in
    d) desktop_file_call='true' ;;
    *) echo "Unknown flag" ;;
  esac
done


fetch_addons_result=$(/home/deck/Applications/ESO-Database/scripts/api/get-addons.sh)
if [ "${fetch_addons_result}" = "ok" ]; then

	if [ -f "${ESODB_META_ADDON_FILE}" ]; then

		mkdir -p "${ESODB_ESO_PROTON_ADDONS_LIVE_PATH}"

  	json=$(cat "${ESODB_META_ADDON_FILE}")
    for row in $(echo "${json=}" | jq -r '.result.data.addons[] | @base64'); do

    	_jq() {
  		 echo ${row} | base64 --decode | jq -r ${1}
  		}

  		addon_name=$(_jq '.addon_name.en')
  		folder_name=$(_jq '.folder_name')
  		download_file_url=$(_jq '.file')
			version_string=$(_jq '.version.string')
			version_integer=$(_jq '.version.integer')

			addon_path="${ESODB_ESO_PROTON_ADDONS_LIVE_PATH}/${folder_name}"
			addon_meta_file_path="${addon_path}/${folder_name}.txt"
			addon_version_string=$(get_addon_string_version "${addon_meta_file_path}")
			addon_version_integer=$(get_addon_integer_version "${addon_meta_file_path}")

			# Skip download and delete folder
			if [ "${folder_name}" = "ESODatabaseGameDataExport" ] && [ ! ${ESODB_ADDON_GAME_DATA_EXPORT_ENABLED} -eq 1 ]; then

				# Remove folder to delete non existing files/folders
				if [ "${folder_name}" != "" ] && [ -d "${addon_path}" ]; then
					rm -fr "${addon_path}"
				fi

				continue
			fi
			if [ "${folder_name}" = "ESODatabaseLeaderboardExport" ] && [ ! ${ESODB_ADDON_LEADERBOARDS_EXPORT_ENABLED} -eq 1 ]; then

				# Remove folder to delete non existing files/folders
				if [ "${folder_name}" != "" ] && [ -d "${addon_path}" ]; then
					rm -fr "${addon_path}"
				fi

				continue
			fi

			if [ ${addon_version_integer} -eq 0 ]; then
				echo -e "[\033[1;35m${folder_name}\033[0m] Installing version ${version_string}..."
			elif [ ! ${addon_version_integer} -eq ${version_integer} ]; then
				echo -e "[\033[1;35m${folder_name}\033[0m] Updating from version ${addon_version_string} to version ${version_string}..."
			else
				echo -e "[\033[1;35m${folder_name}\033[0m] AddOn is up to date! (Version ${addon_version_string})"
				continue
			fi

			# Remove folder to delete non existing files/folders
			if [ "${folder_name}" != "" ] && [ -d "${addon_path}" ]; then
				rm -fr "${addon_path}"
			fi

  		# Create download temp dir
  		mkdir -p "${ESODB_DOWNLOAD_TEMP_DIR}"
  		download_file_name=$(echo "${download_file_url##*/}")
  		temp_file_path="${ESODB_DOWNLOAD_TEMP_DIR}/${download_file_name}"

			echo -e "[\033[1;35m${folder_name}\033[0m] Downloading archive..."
  		curl --silent --header "User-Agent: ${ESODB_API_USER_AGENT}" -o "${temp_file_path}" "${download_file_url}"

  		echo -e "[\033[1;35m${folder_name}\033[0m] Extracting archive..."
  		unzip -qq -o "${temp_file_path}" -d "${ESODB_ESO_PROTON_ADDONS_LIVE_PATH}"

			if [ "${desktop_file_call}" == "true" ]; then
				show_notification "${folder_name} version ${version_string} successfully installed/updated!"
			fi

  		echo -e "[\033[1;35m${folder_name}\033[0m] Done! (Version ${version_string})"
  		echo " "
    done
  else
  	print_error "Could not fetch AddOn meta information!"
  fi
else
	print_error "Could not get AddOns meta information!"
fi

if [ "${desktop_file_call}" == "true" ]; then
	sleep 5
fi
