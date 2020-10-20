Delete() {
		prefix="";
		if [[ "${PERMANENT}" = "1" ]]; then
			urlPath="permanently_delete";
			prefix="Permanently "
		else
			urlPath="delete_v2"
		fi;

		parentRev="";
		if [ -n "${PARENT_REV}" ]; then
			parentRev=", \"parent_rev\": \"${PARENT_REV}\"";
		fi;

		echo "${prefix}Deleting '${DELETE_PATH}'..."
		verboseCurl true -X POST https://api.dropboxapi.com/2/files/${urlPath} \
			--header "Authorization: Bearer ${DROPBOX_TOKEN}" \
			--header "Content-Type: application/json" \
			--data "{\"path\": \"${DELETE_PATH}\"${parentRev}}"
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Delete
fi
