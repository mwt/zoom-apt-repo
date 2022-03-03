#!/bin/bash

#===================================================
# This script generates the repository
#===================================================

REPO_DIR="/home/mirror/my/deb"
STAGING_DIR="/home/mirror/my/staging"
KEYNAME="B7BE5AC2"

# Array of URLs for new .deb
LATEST_URLS=("https://zoom.us/client/latest/zoom_amd64.deb" "https://rstudio.org/download/latest/stable/desktop/bionic/rstudio-latest-amd64.deb")

# Space delimited (string) list of URLs for which to ignore GPG
UNSIGNED=""



#===================================================
# GET DEBS
#===================================================

cd $STAGING_DIR

for LATEST_URL in "${LATEST_URLS[@]}"
do
# obtain filename from end of URL
DEB_FILE=${LATEST_URL##*/}

# create timestamp to see if file changes (if file does not exist, det timestamp to epoch)
touch -r $DEB_FILE ${DEB_FILE}.timestamp || touch --date '1970-01-01 00:00' ${DEB_FILE}.timestamp

# download latest file if newer exists
wget -N $LATEST_URL

# if the timestamp is newer, then get version information
if [[ $DEB_FILE -nt ${DEB_FILE}.timestamp ]]
then
    PKG_VERSION=$(dpkg -f $DEB_FILE Version)
    PKG_NAME=$(dpkg -f $DEB_FILE Package)
    gpg --verify $DEB_FILE
    if [[ $? -eq 0 || "$UNSIGNED " =~ "$LATEST_URL " ]]
    then
        echo "Copying $DEB_FILE to $REPO_DIR/pool/${PKG_NAME:0:1}/$PKG_NAME/${PKG_NAME}_${PKG_VERSION}_amd64.deb" 
        mkdir -p "$REPO_DIR/pool/${PKG_NAME:0:1}/$PKG_NAME/"
        cp $DEB_FILE "$REPO_DIR/pool/${PKG_NAME:0:1}/$PKG_NAME/${PKG_NAME}_${PKG_VERSION}_amd64.deb"
    else
        echo "Not copying because gpg failed"
    fi
else
    echo "File $DEB_FILE not updated."
fi
done

#===================================================
# MAKE REPO
#===================================================

cd $REPO_DIR
# Make package file for all packages
apt-ftparchive --arch amd64 packages ./pool/ | tee ./dists/any/main/binary-amd64/Packages | gzip > ./dists/any/main/binary-amd64/Packages.gz
# Make package file for rstudio
apt-ftparchive --arch amd64 packages ./pool/r/rstudio | tee ./dists/any/rstudio/binary-amd64/Packages | gzip > ./dists/any/rstudio/binary-amd64/Packages.gz
# Make package file for zoom
apt-ftparchive --arch amd64 packages ./pool/z/zoom | tee ./dists/any/zoom/binary-amd64/Packages | gzip > ./dists/any/zoom/binary-amd64/Packages.gz
# Make Release file for all, rstudio, and zoom
apt-ftparchive --arch amd64 release -c ../apt-ftparchive.conf ./dists/any/ > ./dists/any/Release

cd ./dists/any/
# generate Release.gpg
rm -fr Release.gpg; gpg --default-key ${KEYNAME} -abs -o Release.gpg Release

# generate InRelease
rm -fr InRelease; gpg --default-key ${KEYNAME} --clearsign -o InRelease Release
