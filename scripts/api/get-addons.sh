#!/bin/bash

source /home/deck/Applications/ESO-Database/config/config.sh

mkdir -p "${ESODB_META_ADDON_DIR}"

req_result=$(
	curl --silent --request POST "${ESODB_API_GET_ADDON_VERSIONS}" \
		--header "Content-Type: application/x-www-form-urlencoded" \
		--header "User-Agent: ${ESODB_API_USER_AGENT}"
)

if [ $(echo "${req_result}" | jq --raw-output '.status') = "OK" ]; then
	echo "${req_result}" > "${ESODB_META_ADDON_FILE}"
	echo "ok"
else
	echo "error"
fi
