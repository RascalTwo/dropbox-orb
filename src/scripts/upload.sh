Upload() {
		source ./helper.sh
		verboseCurl true -X POST https://content.dropboxapi.com/2/files/upload \
			--header "Authorization: Bearer ${DROPBOX_TOKEN}" \
			--header "Dropbox-API-Arg: {\"path\": \"${UPLOAD_PATH}\", \"mode\": \"overwrite\"}" \
			--header "Content-Type: application/octet-stream" \
			--data-binary @${FILE_PATH}
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Upload
fi
