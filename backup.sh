#!/bin/sh

# This script automatically backs up the fileserver and the MySQL server and is designed to run as a cron-job
# This script should run on the back-upserver
#
# Set up:
#   Install packages: mysql-client
#   Add this machine's SSH pubkey to the fileserver's authorized_keys


# Begin settings #

#local
BASEDIR=/usr/local/backup/

#database
DB_SERVER=192.168.27.120
DB_DATABASE=TestPhotocasus
DB_USER=
DB_PASS=

#fileserver
FS_SERVER=192.168.27.123
FS_PATH=/home/student/dvd_storage/
FS_USER=

# End settings #

BASEPATH=$BASEDIR$(date +"%Y/%B/%d")

if [ -e $BASEPATH ]; then
        echo "Already backed up today!\n\nRemove $BASEPATH to redo backup"
        exit
fi

mkdir -p $BASEPATH/

echo "Backing up the database to $BASEPATH/database.sql"
mysqldump --host $DB_SERVER $DB_DATABASE -u$DB_USER -p$DB_PASS >$BASEPATH/database.sql

echo "Backing up the pictures to $BASEPATH/files/"
scp -r $FS_USER@$FS_SERVER:$FS_PATH $BASEPATH/files/

echo "Back-up finished"
