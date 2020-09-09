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
##################
# If in E+, create access federation
### ASSUMPTION: main JPD has the id of JPD-1, if this is not the case, we'll need to validate what JPD id we are connected to through jfrog CLI.
#
# This will set star access federation from JPD-1 to all other JPDs for ALL security entities.
#
######
BASEURL=`jfrog rt curl --silent --url /api/system/configuration | grep urlBase | sed -E 's/.*>(.*)<.*$/\1/'`
echo $BASEURL
MAIN_SRV_ID=`jfrog rt curl --silent --url /api/system/service_id`
echo $MAIN_SRV_ID
MAIN_ACC_TOKEN=`jfrog rt curl -d "{\\"service_id\\" : \\"${MAIN_SRV_ID}\\"}" -H "Content-Type:application/json" --silent --url /api/security/access/admin/token`
echo $MAIN_ACC_TOKEN
ACC_TOKEN=`echo $MAIN_ACC_TOKEN | jq -c -r .tokenValue`
echo $ACC_TOKEN
MC_TOKEN_FULL=`curl -s -X POST -d "username=${int_Artifactory_user}" -d 'scope=applied-permissions/user' -d 'audience=jfmc@*' -d 'expires_in=3600' -d 'grant_type=client_credentials'  -H "Authorization: Bearer ${ACC_TOKEN}" ${BASEURL}/access/api/v1/oauth/token`
echo $MC_TOKEN_FULL
MC_TOKEN=`echo $MC_TOKEN_FULL | jq -c -r .access_token`
echo $MC_TOKEN
JPDS=`curl --silent -X GET -H "Authorization: Bearer ${MC_TOKEN}" ${BASEURL}/mc/api/v1/jpds`
echo $JPDS
JPD_VALUES=`echo $JPDS | jq -c -r -s '.[] | map_values({ "name": .name, "url": .url, "id": .id})'`
echo $JPD_VALUES
TARGET_JPDS=`echo $JPD_VALUES | jq -c  '. | map (. | select (.id != "JPD-1"))'`
echo $TARGET_JPDS
echo "XXXXX"
echo "{\\"entities\\" : [\\"USERS\\",\\"GROUPS\\",\\"PERMISSIONS\\",\\"TOKENS\\"], \\"targets\\" : ${TARGET_JPDS} }" 
echo "XXXXX"
curl -X PUT -d "{\\"entities\\" : [\\"USERS\\",\\"GROUPS\\",\\"PERMISSIONS\\",\\"TOKENS\\"], \\"targets\\" : ${TARGET_JPDS} }" -H "Content-Type:application/json" -H "Authorization: Bearer ${MC_TOKEN}" ${BASEURL}/mc/api/v1/federation/JPD-1
######################
# End of Access Federartion
#######################




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

BASEURL=`jfrog rt curl --silent --url /api/system/configuration | grep urlBase | sed -E 's/.*>(.*)<.*$/\1/'`
for file in ${dirName}/*.policy; do
    policy="$(b=${file##*/}; echo ${b%.*})"
    curl -u ${int_Artifactory_user}:${int_Artifactory_apikey} -X POST --silent -H "Content-Type: application/json" --data "@${file}" ${BASEURL}/xray/api/v2/policies
done

for file in ${dirName}/*.watch; do
    watch="$(b=${file##*/}; echo ${b%.*})"
    curl -u ${int_Artifactory_user}:${int_Artifactory_apikey} -X POST --silent -H "Content-Type: application/json" --data "@${file}" ${BASEURL}/xray/api/v2/watches
done



