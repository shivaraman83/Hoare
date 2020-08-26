#!/usr/bin/env bash
export LC_ALL=C

#########################################
# This script deletes local repositories and virtual repository that include all.
#
# Pre-reqs:
#  * need to have available:
#      curl  -- for direct REST invocations
#      jfrog -- the jfrog cli tool
#  * artifactory needs to be available and the cli pre-configured with the credentials


check_for_cli() {
        if ! [ -x "$(command -v jfrog)" ]; then
           echo 'Error: jfrog cli is not installed.' >&2
           exit 1
        fi
}
check_for_curl() {
        if ! [ -x "$(command -v curl)" ]; then
           echo 'Error: curl is not installed.' >&2
           exit 1
        fi
}
check_rt_status() {
        if ! [ `jfrog rt ping` = "OK" ]; then
           echo "Artifactory ping failed!"
           exit 1
        fi
}
###### verify jq, curl and cli are installed
check_for_cli
check_for_curl
check_for_jq
######

dirName="config"

####### delete virtual repos
echo "Creating virtual repositories"
for file in ${dirName}/*.virtual; do
    virtual="$(b=${file##*/}; echo ${b%.*})"
    URL="/api/repositories/${virtual}"
    jfrog rt curl -X DELETE ${URL}
done

