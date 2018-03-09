#!/bin/bash
# Backup Source Server, V1

# DEPENDENCIES:
#       rclone, a Source Server made using LGSM (or comment out the serverfiles check),
#       bzip2, at least 2.5x the amount of storage taken up by DIRSTOBACKUP

# Place in a separate folder and point it to the other directories.

# This uses rclone and a local directory to mash things together.
# Very simplistic program, set what you need with variables.

SERVERNAME="tf_trade"
SERVERFILESDIR="/path/to/${SERVERNAME}/serverfiles"
GAMEDIR="tf"
RCLONEDIR="remote:Server Backups/CHECKEM"

DIRSTOBACKUP=("addons" "cfg" "materials" "models" "sound")

if [-d "${SERVERNAME}/serverfiles"]; then
        # We are in the actual server files, stop or we'll delete something!
        echo "${SERVERNAME}/serverfiles exists! We are in danger!"
        exit 1
fi

echo "Working in:"
pwd

rm -rf $SERVERNAME
mkdir $SERVERNAME
for i in ${DIRSTOBACKUP[@]}; do
        echo "Making and setting ${SERVERNAME}/${i}!"
        mkdir $SERVERNAME/$i
        cp -r $SERVERFILESDIR/$GAMEDIR/$i $SERVERNAME/
done

echo "Zipping up!"
tar cf $SERVERNAME.tar $SERVERNAME/
bzip2 $SERVERNAME.tar

echo "UPLOADING! This may take a while..."
rclone copy $SERVERNAME.tar.bz2 "$RCLONEDIR"

echo "Cleaning up!"
rm -rf $SERVERNAME
rm -f $SERVERNAME.tar.bz2
