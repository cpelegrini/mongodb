#!/bin/bash
dbName=$1
dbUser=User # user name
dbPass=123456 # user password
path=~/backups/db
var=`date +"%FORMAT_STRING"`
now=`date +"%m_%d_%Y"`
now=`date +"%Y-%m-%d-%I"`
echo "${now}"
docker exec mongodb sh -c \ 
   "mongodump --authenticationDatabase admin -u ${dbUser} -p ${dbPass} --db=${dbName} --archive" \
   > ${path}-${now}.dump
   # delete backup files older than 30 day
   find ~/backups/*.dump -mtime +30 -delete
