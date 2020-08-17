#!/bin/bash
export LC_ALL=C

#########################################
# This script creates local repositories and virtual repository that include all.
# It also creates groups and permission targets for the repositories.
# Also updates Xray indexes (for the generated repositories), creates policies and watches.
#
# Pre-reqs: 
#  * need to have available:
#      curl  -- for direct REST invocations
#      jfrog -- the jfrog cli tool
#      jq    -- json handling 
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
check_for_jq() {
        if ! [ -x "$(command -v jq)" ]; then
           echo 'Error: jq is not installed.' >&2
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

####### create local repos
echo "Creating local repositories"
for file in ${dirName}/*.local; do
  jfrog rt rc ${file}
done
####### create remote repos
echo "Creating remote repositories"
for file in ${dirName}/*.remote; do
  jfrog rt rc ${file}
done
####### create virtual repos
echo "Creating virtual repositories"
for file in ${dirName}/*.virtual; do
  jfrog rt rc ${file}
done
####### create groups
echo "Creating groups"
for file in ${dirName}/*.group; do
  group="$(b=${file##*/}; echo ${b%.*})"
  jfrog rt curl -X PUT -H "Content-Type: application/json" --data "@${file}" /api/security/groups/$group
done
###### create permission targets
echo "Creating permission targets"
for file in ${dirName}/*.permissiontarget; do
  permissionTarget="$(b=${file##*/}; echo ${b%.*})"
  jfrog rt curl -X PUT -H "Content-Type: application/json" --data "@${file}" /api/v2/security/permissions/$permissionTarget
done

echo "Creating update_indexes XRay body"
REPOS_TO_ADD=`jq -s -c '. as $root | del(.[0]) | map_values({pkg_type: (. as $elem | $root[0].dict[] | select(.from == $elem.packageType) | .to), name: .key, type: "local"})' dict.json ${dirName}/*.local`

read XRAY_URL XRAY_USER XRAY_PASS < <(echo $(cat ~/.jfrog/jfrog-cli.conf | jq '.artifactory[] | select (.isDefault == true) | {url : (.url | sub("\/artifactory\/";"\/xray\/")), user, password }' | jq -r '.url, .user, .password'))

read XRAY_IDX XRAY_NON_IDX < <(echo $(curl -s -u ${XRAY_USER}:${XRAY_PASS} ${XRAY_URL}/api/v1/binMgr/default/repos | jq -c -r '.indexed_repos, .non_indexed_repos'))

XRAY_OUT_NON_IDX=`echo $XRAY_NON_IDX | jq -r -c --argjson toadd $REPOS_TO_ADD '. - $toadd'`
XRAY_OUT_IDX=`echo $XRAY_IDX | jq -r -c --argjson toadd $REPOS_TO_ADD '. + $toadd | unique'`

echo "{\"indexed_repos\":${XRAY_OUT_IDX},\"non_indexed_repos\":${XRAY_OUT_NON_IDX}}" > ${dirName}/update_indexes.index
#------------------------------------------------------------

