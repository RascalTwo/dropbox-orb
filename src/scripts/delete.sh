Delete() {
		echo "Deleting '${DELETE_PATH}'..."
		verboseCurl true -X POST https://api.dropboxapi.com/2/files/delete_v2 \
			--header "Authorization: Bearer ${DROPBOX_TOKEN}" \
			--header "Content-Type: application/json" \
			--data "{\"path\": \"${DELETE_PATH}\"}"
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Delete
fi
