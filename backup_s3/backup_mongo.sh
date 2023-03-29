#!/bin/bash
dbName=$1
dbUser=User # user name
dbPass="password" # user password
var=`date +"%FORMAT_STRING"`
now=`date +"%m_%d_%Y"`
now=`date +"%Y-%m-%d-%I"`
path="/home/user/backups_mongo"
fileName="${path}/${dbName}-${now}.dump"
docker exec vialize-db sh -c "mongodump --authenticationDatabase admin -u ${dbUser} -p '${dbPass}' --db=${dbName} --archive" > "${fileName}"
# delete backup files older than 30 day
cd ${path}
find *.dump -mtime +30 -delete
