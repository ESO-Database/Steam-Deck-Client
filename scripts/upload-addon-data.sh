#!/bin/bash

source /home/deck/Applications/ESO-Database/config/config.sh
source /home/deck/Applications/ESO-Database/scripts/tools/functions.sh
source /home/deck/Applications/ESO-Database/scripts/tools/uploader.sh

if [[ -f "${ESODB_ESO_PROTON_EXPORT_ADDON_SV_FILE}" ]]; then
	upload_sv_file "${ESODB_UPLOAD_EXPORT_URL}" "${ESODB_ESO_PROTON_EXPORT_ADDON_SV_FILE}" "${ESODB_SV_EXPORT_FILE_NAME}" "true"
	show_notification "ESO-Database Export AddOn data has been uploaded!"
fi

if [[ -f "${ESODB_ESO_PROTON_GAME_DATA_ADDON_SV_FILE}" ]]; then
	upload_sv_file "${ESODB_UPLOADER_GAME_DATA_URL}" "${ESODB_ESO_PROTON_GAME_DATA_ADDON_SV_FILE}" "${ESODB_SV_GAME_DATA_FILE_NAME}" "true"
fi

if [[ -f "${ESODB_ESO_PROTON_LEADERBOARD_ADDON_SV_FILE}" ]]; then
	upload_sv_file "${ESODB_UPLOADER_LEADERBOARD_DATA_URL}" "${ESODB_ESO_PROTON_LEADERBOARD_ADDON_SV_FILE}" "${ESODB_SV_LEADERBOARD_FILE_NAME}" "true"
fi

print_success "Done"
