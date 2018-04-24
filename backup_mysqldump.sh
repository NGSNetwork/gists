#!/bin/bash
# Backup MySQL DBs, V1

# DEPENDENCIES:
#       rclone, mysqldump, bzip2, at least 2.5x the space taken up by dbs

# Place in a separate folder and configure the settings.

# This uses rclone and a local directory to mash things together.
# Very simplistic program, set what you need with variables.

DUMPFOLDER="dump"
DUMPFILENAME="dumpfile"
DBTOBACKUP="this that theother"
WORKINGDIRECTORY="/path/to/workspace"
DBUSER="user"
DBPASS="password"
RCLONEDIR="remote:path/to/backups"

cd $WORKINGDIRECTORY

echo "Working in:"
pwd
rm -rf $WORKINGDIRECTORY/$DUMPFOLDER
mkdir $WORKINGDIRECTORY/$DUMPFOLDER
echo "Dumping file to ${DUMPFOLDER}/${DUMPFILENAME}.sql.bz2"
mysqldump -u $DBUSER -p$DBPASS --databases $DBTOBACKUP | bzip2 > $WORKINGDIRECTORY/$DUMPFOLDER/$DUMPFILENAME.sql.bz2

echo "UPLOADING! This may take a while..."
rclone copy $WORKINGDIRECTORY/$DUMPFOLDER "$RCLONEDIR"

echo "Cleaning up!"
rm -rf $WORKINGDIRECTORY/$DUMPFOLDER
