#!/bin/bash

source /home/deck/Applications/ESO-Database/config/config.sh
source /home/deck/Applications/ESO-Database/scripts/tools/functions.sh

user_name=""
desktop_file_call="false"

while getopts 'd' flag; do
  case "${flag}" in
    d) desktop_file_call='true' ;;
    *) echo "Unknown flag" ;;
  esac
done

if [ -f ~/.eso-database-client/auth ]; then
	user_name_json=$(cat ~/.eso-database-client/auth | jq --raw-output '.user_name')
	if [ ! -z "${user_name_json}" ]; then
		user_name="${user_name_json}"
	fi
fi

if [ ! -z "${user_name}" ]; then
	rm -f "${ESODB_AUTH_FILE}"

	if [ "${desktop_file_call}" == "true" ]; then
		show_notification "The user ${user_name} has been logged out. If you want to log in with another account, please run the login shortcut from the launcher."
	else
		printf "The user \033[1;34m${user_name}\033[0m has been logged out.\n\nIf you want to log in with another account, please run the login.sh script.\n"
	fi
else
	if [ "${desktop_file_call}" == "true" ]; then
		show_notification "You are not logged in, so no logout is required! If you want to log in, please run the log in shortcut from the launcher."
	else
		printf "You are not logged in, so no logout is required!\n\nIf you want to log in, please run the login.sh script.\n"
	fi
fi
