#!/bin/bash
# Backup MySQL DBs, V1

# DEPENDENCIES:
#       rclone, mysqldump, bzip2, tar, at least 2.5x the space taken up by dbs

# Place in a separate folder and configure the settings.

# This uses rclone and a local directory to mash things together.
# Very simplistic program, set what you need with variables.

DUMPFOLDER="mysqldump"
DUMPFILENAME="mysql_dump"
DBTOBACKUP="db1 db2 db3 db4"
DBUSER=""
DBPASS=""
RCLONEDIR="remote:Backups/Databases"

echo "Working in:"
pwd
rm -rf $DUMPFOLDER
mkdir $DUMPFOLDER
echo "Dumping file to ${DUMPFOLDER}/${DUMPFILENAME}.sql.bz2"
mysqldump -u $DBUSER -p$DBPASS --databases $DBTOBACKUP | bzip2 > $DUMPFOLDER/$DUMPFILENAME.sql.bz2

echo "UPLOADING! This may take a while..."
rclone copy $DUMPFOLDER "$RCLONEDIR"

# Clean up after yourself
rm -rf $DUMPFOLDER
