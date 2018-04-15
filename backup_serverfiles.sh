#!/bin/bash
# Backup Source Server, V1

# DEPENDENCIES:
#       rclone, a Source Server made using LGSM (or comment out the serverfiles check),
#       bzip2, at least 2.5x the amount of storage taken up by DIRSTOBACKUP

# Place in a separate folder and point it to the other directories.

# This uses rclone and a local directory to mash things together.
# Very simplistic program, set what you need with variables.

SERVERNAME="tf2server"
SERVERFILESDIR="/path/to/${SERVERNAME}/serverfiles"
GAMEDIR="tf"
RCLONEDIR="REMOTE:path to/folder/on/remote"
DIRSTOBACKUP=("addons" "cfg" "materials" "models" "sound")
WORKINGDIRECTORY="/path/to/workspace"

cd $WORKINGDIRECTORY

if [[ -d "${SERVERNAME}/serverfiles" && ! -L "${SERVERNAME}/serverfiles" ]]; then
        # We are in the actual server files, stop or we'll delete something!
        echo "${SERVERNAME}/serverfiles exists! We are in danger!"
        exit 1
fi

echo "Working in:"
pwd

rm -rf $WORKINGDIRECTORY/$SERVERNAME
rm -f $WORKINGDIRECTORY/$SERVERNAME.tar.bz2
mkdir $WORKINGDIRECTORY/$SERVERNAME

echo "Copying and creating the file structure!"
for i in ${DIRSTOBACKUP[@]}; do
        echo "Making and setting ${WORKINGDIRECTORY}/${SERVERNAME}/${i}!"
        mkdir $WORKINGDIRECTORY/$SERVERNAME/$i
        cp -r $SERVERFILESDIR/$GAMEDIR/$i $WORKINGDIRECTORY/$SERVERNAME/
done

echo "Zipping up!"
tar cjf $WORKINGDIRECTORY/$SERVERNAME.tar.bz2 $WORKINGDIRECTORY/$SERVERNAME/

echo "UPLOADING! This may take a while..."
rclone copy $WORKINGDIRECTORY/$SERVERNAME.tar.bz2 "$RCLONEDIR"

echo "Cleaning up!"
rm -rf $WORKINGDIRECTORY/$SERVERNAME
rm -f $WORKINGDIRECTORY/$SERVERNAME.tar.bz2
