# Strategy to backup mongo to S3

How to backup periodically and send to S3 repository.

## Steps

1. Mongodb backup:

   * File name: backup_mongo.sh
   ```bash
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
   ```

   * How to use:
   ```bash
   chmod +x backup_mongo.sh
   backup_mongo.sh database_name
   ```

   * Create a crontab:
   ```bash
   crontab -e

   # backup mongo every hour at minute 0
   0 * * * * ~/backup_mongo.sh
   ```
   

2. Send backup to S3:

   * Create a S3 bucket.
   * Create a user and a policy to allow upload files. Policy example:
   ```json
      {
          "Version": "2012-10-17",
          "Statement": [
              {
                  "Effect": "Allow",
                  "Action": [
                      "s3:ListBucket"
                  ],
                  "Resource": [
                      "arn:aws:s3:::my-bkp-mongodb"
                  ]
              },
              {
                  "Effect": "Allow",
                  "Action": [
                      "s3:PutObject"
                  ],
                  "Resource": [
                      "arn:aws:s3:::my-bkp-mongodb/*"
                  ]
              }
          ]
      }
   ```


   * Run docker to start a service to upload the backup files:
   ```bash
      docker run --name s3sync-mongodb \
              -e ACCESS_KEY=mykey \
              -e SECRET_KEY=mysecret \
              -e S3_PATH=s3://my-bkp-mongodb/server-x/ \
              -e 'CRON_SCHEDULE=10 * * * *' \
              -v /backups:/data:ro \
              istepanov/backup-to-s3
   ```
   The service will send backups to s3 every hour at minute 10.

## References

* [Docker backup-to-s3](https://hub.docker.com/r/istepanov/backup-to-s3)
* [Github backup-to-s3](https://github.com/istepanov/docker-backup-to-s3)
