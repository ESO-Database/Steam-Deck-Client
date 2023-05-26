#!/bin/bash

user_name=""

if [ -f "${ESODB_APP_DATA_PATH}/auth" ]; then
	user_name_json=$(cat "${ESODB_APP_DATA_PATH}/auth" | jq --raw-output '.user_name')
	if [ ! -z "${user_name_json}" ]; then
		user_name="${user_name_json}"
	fi
fi

echo ${user_name}
