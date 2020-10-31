Download() {
		echo "Downloading '${DOWNLOAD_PATH}'..."
		verboseCurl false -X POST https://content.dropboxapi.com/2/files/download \
			--header "Authorization: Bearer ${DROPBOX_TOKEN}" \
			--header "Dropbox-API-Arg: {\"path\": \"${DOWNLOAD_PATH}\"}"

		# Return result if not successful
		RESULT=$?
		if [ $RESULT -ne 0 ]; then
			# If the ignore_nonexistent flag is true and the
			# file is not found, silently ignore the error
			if [[ "${IGNORE_NONEXISTENT}" = "1" ]] && [[ "$(jq .error_summary < output)" = "\"path/not_found/\"" ]]; then
				echo "File not found, silently ignoring..."
				return 0;
			fi
			return $RESULT;
		fi

		# Otherwise move file to desired location
		mv ./output "${FILE_PATH}"
		echo "File downloaded to: ${FILE_PATH}"
		stat "${FILE_PATH}"
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
		Download
fi
