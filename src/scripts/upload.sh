verboseCurl(){
		# First argument is if to display output or not, rest are passed to curl
		display=$1
		shift
		# Redirect output to file while outputting HTTP code
		STATUSCODE=$(curl --silent --output ./output --write-out "%{http_code}" "$@")

		# Treat Non-200 as error, output response and return 1
		if test "$STATUSCODE" -ne 200; then
				echo "HTTP Response ${STATUSCODE}: "
				cat ./output
				rm ./output
				return 1
		fi

		# Otherwise return 0, but first display and delete if output asked
		if [ "$display" != "false" ]; then
			cat ./output
			rm ./output
		fi
		return 0
}

Upload() {
		verboseCurl true -X POST https://content.dropboxapi.com/2/files/upload \
			--header "Authorization: Bearer ${DROPBOX_TOKEN}" \
			--header "Dropbox-API-Arg: {\"path\": \"${UPLOAD_PATH}\", \"mode\": \"overwrite\"}" \
			--header "Content-Type: application/octet-stream" \
			--data-binary @"${FILE_PATH}"
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Upload
fi
