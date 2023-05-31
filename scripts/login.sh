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


print_status "Requesting login token..."

auth_req=$(curl --silent "${ESODB_AUTH_API_URL}" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'source=steam-deck')

auth_req_status=$(echo "${auth_req}" | jq --raw-output '.status')
if [ "${auth_req_status}" = "true" ]; then

	auth_req_token=$(echo "${auth_req}" | jq --raw-output '.request_token')

	if [ "${auth_req_token}" != "" ]; then

		if [ "${desktop_file_call}" == "true" ]; then
			show_notification "Please authenticate on the opened website with your ESO-Database account."
		fi

		echo "Please authenticate on the opened website with your ESO-Database account. After authentication, please return to this window..."
		echo "Open this link if no browser window opens automatically:"
		echo "${ESODB_AUTH_USER_URL}/${auth_req_token}"
		setsid xdg-open "${ESODB_AUTH_USER_URL}/${auth_req_token}" >/dev/null 2>&1

    	AUTH_RESULT="wait"
    	AUTH_LOOP_TIMEOUT="false"
    	AUTH_LOOP_START_DATE=$(date +%s)

    	until [[ ${AUTH_RESULT} = "received" ]] || [[ ${AUTH_LOOP_TIMEOUT} = "true" ]]
      do

      	auth_status_req=$(curl --silent "${ESODB_AUTH_API_GET_AUTH_REQUEST_STATUS}" \
          --header "X-Request-Token: ${auth_req_token}" \
          --header 'Content-Type: application/x-www-form-urlencoded' \
          --data-urlencode 'source=steam-deck')

				req_status=$(echo "${auth_status_req}" | jq --raw-output '.status')
				req_auth_status=$(echo "${auth_status_req}" | jq --raw-output '.auth_status')

				if [ ${req_status} = false ]; then
					error_msg=$(echo "${auth_status_req}" | jq --raw-output '.error')

					if [ "${desktop_file_call}" == "true" ]; then
						show_notification "${error_msg}"
					fi

					print_error "${error_msg}"
					break
				fi

				if [ "${req_auth_status}" = "failed" ]; then
					error_msg=$(echo "${auth_status_req}" | jq --raw-output '.error')

					if [ "${desktop_file_call}" == "true" ]; then
						show_notification "Authentication failed, please try again!"
					fi

					print_error "Authentication failed, please try again!"
					break
				fi

				if [ "${req_auth_status}" = "success" ]; then
					mkdir -p "${ESODB_APP_DATA_PATH}"
					echo "${auth_status_req}" > "${ESODB_AUTH_FILE}"

					user_name=$(echo "${auth_status_req}" | jq --raw-output '.user_name')

					show_notification "You are now logged in as ${user_name}!"
					print_success "You are now logged in as ${user_name}!"
					break
				fi

					now=$(date +%s)
        	auth_loop_runtime_seconds=$((now-AUTH_LOOP_START_DATE))

        	# Check if task should run in this loop
        	if [ ${auth_loop_runtime_seconds} -gt ${ESODB_LOGIN_LOOP_TIMEOUT_SECONDS} ]; then
        		AUTH_LOOP_TIMEOUT="true"
        	fi
      done
	else

		if [ "${desktop_file_call}" == "true" ]; then
			show_notification "Could not receive login request token. Please try again!"
		fi

		print_error "Could not receive login request token. Please try again!"
	fi
else

	if [ "${desktop_file_call}" == "true" ]; then
		show_notification "Could not get login request in case of an internal server error. Please try again!"
	fi

	print_error "Could not get login request in case of an internal server error. Please try again!"
fi
