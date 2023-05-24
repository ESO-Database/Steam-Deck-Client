#!/bin/bash

source /home/deck/Applications/ESO-Database/config/config.sh
source /home/deck/Applications/ESO-Database/scripts/tools/functions.sh
source /home/deck/Applications/ESO-Database/scripts/tools/uploader.sh

# Get initial file times
LAST_CHANGE_TIME_MAIN=$(get_file_change_time "${ESODB_ESO_PROTON_EXPORT_ADDON_SV_FILE}")
LAST_CHANGE_TIME_GAME_DATA=$(get_file_change_time "${ESODB_ESO_PROTON_GAME_DATA_ADDON_SV_FILE}")
LAST_CHANGE_TIME_LEADERBOARD=$(get_file_change_time "${ESODB_ESO_PROTON_LEADERBOARD_ADDON_SV_FILE}")


# Loop until the script is killed
while true
do

	#	Get most recent config
  source /home/deck/Applications/ESO-Database/config/config.sh

	CURRENT_CHANGE_TIME_MAIN=$(get_file_change_time "${ESODB_ESO_PROTON_EXPORT_ADDON_SV_FILE}")
	CURRENT_CHANGE_TIME_GAME_DATA=$(get_file_change_time "${ESODB_ESO_PROTON_GAME_DATA_ADDON_SV_FILE}")
	CURRENT_CHANGE_TIME_LEADERBOARD=$(get_file_change_time "${ESODB_ESO_PROTON_LEADERBOARD_ADDON_SV_FILE}")

	if [ "${CURRENT_CHANGE_TIME_MAIN}" != "${LAST_CHANGE_TIME_MAIN}" ]; then
		LAST_CHANGE_TIME_MAIN=${CURRENT_CHANGE_TIME_MAIN}
		upload_sv_file "${ESODB_UPLOAD_EXPORT_URL}" "${ESODB_ESO_PROTON_EXPORT_ADDON_SV_FILE}" "${ESODB_SV_EXPORT_FILE_NAME}"
	fi

	if [ ${ESODB_ADDON_GAME_DATA_EXPORT_ENABLED} -eq 1 ]; then
		if [ "${CURRENT_CHANGE_TIME_GAME_DATA}" != "${LAST_CHANGE_TIME_GAME_DATA}" ]; then
			if [ "${ESODB_UPLOADER_ENABLE_GAME_DATA}" -eq 1 ]; then
				LAST_CHANGE_TIME_GAME_DATA=${CURRENT_CHANGE_TIME_GAME_DATA}
				upload_sv_file "${ESODB_UPLOADER_GAME_DATA_URL}" "${ESODB_ESO_PROTON_GAME_DATA_ADDON_SV_FILE}" "${ESODB_SV_GAME_DATA_FILE_NAME}"
			fi
		fi
	fi

	if [ ${ESODB_ADDON_LEADERBOARDS_EXPORT_ENABLED} -eq 1 ]; then
		if [ "${CURRENT_CHANGE_TIME_LEADERBOARD}" != "${LAST_CHANGE_TIME_LEADERBOARD}" ]; then
			if [ "${ESODB_UPLOADER_ENABLE_LEADERBOARD_DATA}" -eq 1 ]; then
				LAST_CHANGE_TIME_LEADERBOARD=${CURRENT_CHANGE_TIME_LEADERBOARD}
				upload_sv_file "${ESODB_UPLOADER_LEADERBOARD_DATA_URL}" "${ESODB_ESO_PROTON_LEADERBOARD_ADDON_SV_FILE}" "${ESODB_SV_LEADERBOARD_FILE_NAME}"
			fi
		fi
	fi

	sleep ${ESODB_UPLOADER_SLEEP_TIME}
done
