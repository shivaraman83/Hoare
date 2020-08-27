#!/bin/bash
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
repositoryBaseURL="/api/repositories/"
groupsBaseURL="/api/security/groups/"
permsBaseURL="/api/security/permissions/"

####### delete virtual repos
echo "deleting virtual repositories"
for file in ${dirName}/*.virtual; do
    virtual="$(b=${file##*/}; echo ${b%.*.*})"
    virtualURL="${repositoryBaseURL}${virtual}"
    jfrog rt curl -X DELETE ${virtualURL}
done
####### delete local repos
echo "Deleting local repositories"
for file in ${dirName}/*.local; do
    local="$(b=${file##*/}; echo ${b%.*.*})"
    localURL="${repositoryBaseURL}${local}"
    jfrog rt curl -X DELETE ${localURL}
done
####### delete remote repos
echo "Deleting remote repositories"
for file in ${dirName}/*.remote; do
    remote="$(b=${file##*/}; echo ${b%.*.*})"
    remoteURL="${repositoryBaseURL}${remote}"
    jfrog rt curl -X DELETE ${remoteURL}
done
####### delete groups
echo "Deleting groups"
for file in ${dirName}/*.group; do
  group="$(b=${file##*/}; echo ${b%.*})"
  groupURL="${groupsBaseURL}${group}"
  jfrog rt curl -X DELETE ${groupURL}
done
