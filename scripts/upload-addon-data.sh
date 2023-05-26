#!/bin/bash

source /home/deck/Applications/ESO-Database/config/config.sh
source /home/deck/Applications/ESO-Database/scripts/tools/functions.sh
source /home/deck/Applications/ESO-Database/scripts/tools/uploader.sh


desktop_file_call="false"

while getopts 'd' flag; do
  case "${flag}" in
    d) desktop_file_call='true' ;;
    *) echo "Unknown flag" ;;
  esac
done

if [ -f "${ESODB_ESO_PROTON_EXPORT_ADDON_SV_FILE}" ]; then
	upload_sv_file "${ESODB_UPLOAD_EXPORT_URL}" "${ESODB_ESO_PROTON_EXPORT_ADDON_SV_FILE}" "${ESODB_SV_EXPORT_FILE_NAME}" "true" "true"
fi

if [ ${ESODB_ADDON_GAME_DATA_EXPORT_ENABLED} -eq 1 ]; then
	if [ -f "${ESODB_ESO_PROTON_GAME_DATA_ADDON_SV_FILE}" ]; then
		upload_sv_file "${ESODB_UPLOADER_GAME_DATA_URL}" "${ESODB_ESO_PROTON_GAME_DATA_ADDON_SV_FILE}" "${ESODB_SV_GAME_DATA_FILE_NAME}" "true"
	fi
fi

if [ ${ESODB_ADDON_LEADERBOARDS_EXPORT_ENABLED} -eq 1 ]; then
	if [ -f "${ESODB_ESO_PROTON_LEADERBOARD_ADDON_SV_FILE}" ]; then
		upload_sv_file "${ESODB_UPLOADER_LEADERBOARD_DATA_URL}" "${ESODB_ESO_PROTON_LEADERBOARD_ADDON_SV_FILE}" "${ESODB_SV_LEADERBOARD_FILE_NAME}" "true"
	fi
fi

print_success "Done"

if [ "${desktop_file_call}" == "true" ]; then
	sleep 5
fi
