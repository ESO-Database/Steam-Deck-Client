#!/bin/bash

print_status () {
  printf "\033[1m$1\033[0m\n\n"
}
print_error () {
  printf "\n"
  printf "\033[1;31m-----------------------\033[0m\n"
	printf "\033[1;31m------   ERROR   ------\033[0m\n"
	printf "\033[1;31m-----------------------\033[0m\n"
	printf "\033[0;31m$1\033[0m\n"
}
print_success () {
	printf "\n"
	printf "\033[1;32m$1\033[0m\n"
}

show_notification () {
	expire_time="${ESODB_DESKTOP_NOTIFICATIONS_EXPIRE:-10000}"
	notify-send --expire-time=${expire_time} --icon=/home/deck/Applications/ESO-Database/assets/images/logo.png "ESO-Database Client" "$1"
}

get_auth_secure_token () {

	auth_secure_token=""

	if [ -f /home/deck/.eso-database-client/auth ]; then
		auth_secure_token_json=$(cat /home/deck/.eso-database-client/auth | jq --raw-output '.token')
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
