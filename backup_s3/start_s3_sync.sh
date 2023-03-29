#!/bin/bash
docker run --name s3sync-mongodb \
   -e ACCESS_KEY=mykey \
   -e SECRET_KEY=mysecret \
   -e S3_PATH=s3://my-bkp-mongodb/server-x/ \
   -e 'CRON_SCHEDULE=10 * * * *' \
   -v /backups:/data:ro \
   istepanov/backup-to-s3
