#!/bin/bash

auth_req_token=""

if [ -f ~/.eso-database-client/auth ]; then
	auth_token_json=$(cat ~/.eso-database-client/auth | jq --raw-output '.auth_token')
	if [ ! -z "${auth_token_json}" ]; then
		auth_req_token="${auth_token_json}"
	fi
fi

echo "${auth_req_token}"
