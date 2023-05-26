#!/bin/bash

print_status () {
  echo -e "\033[1m$1\033[0m\n\n"
}

print_error () {
  echo -e "\n"
  echo -e "\033[1;31m-----------------------\033[0m\n"
	echo -e "\033[1;31m------   ERROR   ------\033[0m\n"
	echo -e "\033[1;31m-----------------------\033[0m\n"
	echo -e "\033[0;31m$1\033[0m\n"
}

print_success () {
	echo -e "\n"
	echo -e "\033[1;32m$1\033[0m\n"
}

print_info_warning () {
	echo -e "\033[0;33m$1\033[0m\n"
}

show_notification () {
	expire_time="${ESODB_DESKTOP_NOTIFICATIONS_EXPIRE:-10000}"
	notify-send --expire-time=${expire_time} --icon=/home/deck/Applications/ESO-Database/assets/images/logo.png "ESO-Database Client" "$1"
}

get_auth_secure_token () {

	auth_secure_token=""

	if [ -f "${ESODB_APP_DATA_PATH}/auth" ]; then
		auth_secure_token_json=$(cat "${ESODB_APP_DATA_PATH}/auth" | jq --raw-output '.token')
		if [ ! -z "${auth_secure_token_json}" ]; then
			auth_secure_token="${auth_secure_token_json}"
		fi
	fi

	echo "${auth_secure_token}"
}

get_file_change_time () {

	if [ -f "$1" ]; then
  	change_time=`stat -c %Z "$1"`
  else
  	change_time=0
  fi

  echo ${change_time}
}

get_addon_string_version () {

	version=0
	if [ -f "$1" ]; then
		version=$(cat "$1" | grep "## Version:")
    version="${version/\#\#\ Version:\ /""}"
	fi

	echo "${version}"
}

get_addon_integer_version () {

	version=0
	if [ -f "$1" ]; then
		version=$(cat "$1" | grep "## IntVersion:")
    version="${version/\#\#\ IntVersion:\ /""}"
	fi

	echo "${version}"
}

