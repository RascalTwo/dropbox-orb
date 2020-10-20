Upload() {
		echo "Uploading '${FILE_PATH}' to '${UPLOAD_PATH}'..."

		clientModified="";
		if [ -n "${CLIENT_MODIFIED}" ]; then
			clientModified=", \"client_modified\": \"${CLIENT_MODIFIED}\"";
		fi;

		[[ "${AUTORENAME}" = "1" ]] && AUTORENAME="true" || AUTORENAME="false"
		[[ "${MUTE}" = "1" ]] && MUTE="true" || MUTE="false"
		[[ "${STRICT_CONFLICT}" = "1" ]] && STRICT_CONFLICT="true" || STRICT_CONFLICT="false"

		verboseCurl true -X POST https://content.dropboxapi.com/2/files/upload \
			--header "Authorization: Bearer ${DROPBOX_TOKEN}" \
			--header "Dropbox-API-Arg: {\"path\": \"${UPLOAD_PATH}\", \"mode\": \"${MODE}\", \"autorename\": ${AUTORENAME}, \"mute\": ${MUTE}, \"strict_conflict\": ${STRICT_CONFLICT}${clientModified}}" \
			--header "Content-Type: application/octet-stream" \
			--data-binary @"${FILE_PATH}"
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Upload
fi
