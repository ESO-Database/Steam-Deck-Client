#!/bin/bash

upload_sv_file () {

	# Wait a few seconds until the ESO logout screen is over
	sleep 10

	ENDPOINT="$1"
	SV_FILE_PATH="$2"
	SV_FILE_NAME="$3"

  auth_secure_token=$(get_auth_secure_token)
	upload_name=""
	is_compressed=0

	mkdir -p "${ESODB_UPLOADER_TMP_PATH}"
	cp -frp "${SV_FILE_PATH}" "${ESODB_UPLOADER_TMP_PATH}/${SV_FILE_NAME}"

	if [ ${ESODB_UPLOADER_COMPRESSION} -eq 1 ]; then

		# Fallback to default compression if an invalid range is provided
		if [ ${ESODB_UPLOADER_COMPRESSION_LEVEL} -ge 10 ] || [ ${ESODB_UPLOADER_COMPRESSION_LEVEL} -le 0 ]; then
			ESODB_UPLOADER_COMPRESSION_LEVEL=5
		fi

		(cd "${ESODB_UPLOADER_TMP_PATH}"; tar cf "${SV_FILE_NAME}.tar" "${SV_FILE_NAME}")
		(cd "${ESODB_UPLOADER_TMP_PATH}"; gzip -${ESODB_UPLOADER_COMPRESSION_LEVEL} "${SV_FILE_NAME}.tar")

		is_compressed=1
		upload_name="${SV_FILE_NAME}.tar.gz"
	else
		upload_name="${SV_FILE_NAME}"
	fi

	echo "Uploading ${upload_name}"
	curl --silent "${ENDPOINT}" \
		--header "User-Agent: ${ESODB_API_USER_AGENT}" \
		--header "X-User-Token: ${auth_secure_token}" \
		--form "file=@${ESODB_UPLOADER_TMP_PATH}/${upload_name}" \
		--form "compressed=${is_compressed}"

	rm -f "${ESODB_UPLOADER_TMP_PATH}/${SV_FILE_NAME}"
  rm -f "${ESODB_UPLOADER_TMP_PATH}/${SV_FILE_NAME}.tar"
  rm -f "${ESODB_UPLOADER_TMP_PATH}/${SV_FILE_NAME}.tar.gz"
}
