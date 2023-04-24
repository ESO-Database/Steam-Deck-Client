#!/bin/bash

user_name=""

if [ -f ~/.eso-database-client/auth ]; then
	user_name_json=$(cat ~/.eso-database-client/auth | jq --raw-output '.user_name')
	if [ ! -z "${user_name_json}" ]; then
		user_name="${user_name_json}"
	fi
fi

echo ${user_name}
