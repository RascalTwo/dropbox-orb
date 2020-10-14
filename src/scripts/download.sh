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

Download() {
		echo "Downloading '${DOWNLOAD_PATH}'..."
		verboseCurl false -X POST https://content.dropboxapi.com/2/files/download \
			--header "Authorization: Bearer ${DROPBOX_TOKEN}" \
			--header "Dropbox-API-Arg: {\"path\": \"${DOWNLOAD_PATH}\"}"

		# Return result if not successful
		RESULT=$?
		if [ $RESULT -ne 0 ]; then
			return $RESULT
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
