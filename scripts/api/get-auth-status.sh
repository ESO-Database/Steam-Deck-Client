#!/bin/bash

source /home/deck/Applications/ESO-Database/config/config.sh

auth_req_token=$(/home/deck/Applications/ESO-Database/scripts/tools/get-auth-request-token.sh)

IFS=$'\n' read -d "" body status_code  < <(
	curl \
	--silent \
	--header "X-Request-Token: ${auth_req_token}" \
	--header "Content-Type: application/x-www-form-urlencoded" \
	--header "User-Agent: ${ESODB_API_USER_AGENT}" \
	--data-urlencode "source=${ESODB_AUTH_SOURCE}" \
	-w "\n%{http_code}\n" \
	"${ESODB_AUTH_API_GET_AUTH_STATUS}"
)

if [ "${status_code}" = "200" ]; then

	echo "${body}" | jq -e . >/dev/null 2>&1
	if [ ${PIPESTATUS[1]} -eq 0 ]; then

		status=$(echo "${body}" | jq --raw-output '.status')
    auth_status=$(echo "${body}" | jq --raw-output '.auth_status')

    if [ ${status} = true ]; then
    	if [ "${auth_status}" = "success" ]; then
    		echo "true"
    	else
    		echo "false"
    	fi
    else
    	echo "false"
    fi
	else
		echo "error"
	fi
else
	echo "error"
fi
