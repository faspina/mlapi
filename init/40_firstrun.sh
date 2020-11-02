#!/bin/bash
#
# 40_firstrun.sh
#
#
# Github URL for opencv zip file download.
# Current default is to pull the version 4.3.0 release.
#
# Search for config files, if they don't exist, create the default ones

# Set ownership for unRAID
PUID=${PUID:-99}
PGID=${PGID:-100}
usermod -o -u $PUID nobody
usermod -g $PGID nobody
usermod -d /config nobody

# Set ownership for mail
usermod -a -G mail www-data

# Change some ownership and permissions

# remove and replace
rm /mlapi/mlapiconfig.ini
cp /config/mlapiconfig.ini /mlapi/mlapiconfig.ini
echo "Copy mlapiconfig.ini"

rm /mlapi/secrets.ini
cp /config/secrets.ini /mlapi/secrets.ini
echo "Copy secrets.ini"

rm -f -r /mlapi/db
mkdir /mlapi/db
cp /config/db/*.* /mlapi/db/
echo "Copy mlapi/db"


rm -f -r /mlapi/known_faces
mkdir /mlapi/known_faces
cp /config/known_faces/*.* /mlapi/known_faces/
echo Copy "known_faces"

echo "move the latest get_models script over"
rm -f -r /config/get_models.sh
cp /mlapi/get_models.sh /config/


if [ ! -d /config/models/yolov3 ]; then
	echo "Downloading yolo models to config"
	cd /config
	chmod +x .get_models.sh
	./get_models.sh
else
	echo "Yolo V3 files have already been downloaded, skipping..."
fi

if [ ! -f /config/models/coral_edgetpu/coco_indexed.names ]; then
	echo "Downloading Edge TPU to config"
	cd /config
	chmod +x .get_models.sh
	INSTALL_CORAL_EDGETPU=yes ./get_models.sh
else
	echo "EDGE PTU files have already been downloaded, skipping..."
fi




#if [ ! -d /mlapi/opencv ]; then
	echo "Creating opencv folder in config folder"
#	mkdir /mlapi/opencv
#fi

# Handle the opencv.sh file
#if [ ! -f /mlapi/opencv/opencv.sh ]; then
#	cp /config/opencv/opencv.sh /mlapi/opencv/opencv.sh
#	echo "File opencv.sh copied"
#else
#	echo "File opencv.sh already moved"
#fi

#if [ ! -f /mlapi/opencv/debug_opencv.sh ]; then
#	cp /config/opencv/debug_opencv.sh /mlapi/opencv/debug_opencv.sh
#	echo "File debug_opencv.sh copied"
#else
#	echo "File debug_opencv.sh already moved"
#fi

#if [ ! -f /mlapi/opencv/opencv_ok ]; then
#	echo "no" > /mlapi/opencv/opencv_ok
#fi



# Compile opencv
#echo "Compiling opencv - this will take a while..."
#if [ -f /mlapi/opencv/opencv_ok ] && [ `cat /mlapi/opencv/opencv_ok` = 'yes' ]; then
#	if [ ! -f /root/setup.py ]; then
#		if [ -x /mlapi/opencv/opencv.sh ]; then
#			/mlapi/opencv/opencv.sh quiet >/dev/null
#		fi
#	fi
#else
#	if [ -f /root/opencv_compile.sh ]; then
#		chmod +x /root/opencv_compile.sh
#		/root/opencv_compile.sh >/dev/null
#	fi
#fi




chmod 777 /mlapi
chmod 666 /mlapi/*

echo "Starting services..."
cd mlapi
python3 ./mlapi.py -c mlapiconfig.ini
