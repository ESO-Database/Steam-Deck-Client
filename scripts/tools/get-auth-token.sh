#!/bin/bash

auth_token=""

if [ -f ~/.eso-database-client/auth ]; then
	auth_token_json=$(cat ~/.eso-database-client/auth | jq --raw-output '.token')
	if [ ! -z "${auth_token_json}" ]; then
		auth_token="${auth_token_json}"
	fi
fi

echo "${auth_token}"
