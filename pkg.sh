#!/bin/bash

export data_dir="data"
export output_dir="dist"
export package_name="accelerate"
export control_dir="control"

rm -rf $output_dir control.tar.gz data.tar.gz
mkdir $output_dir

export CODESIGN_ALLOCATE=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/codesign_allocate
info=`codesign -f -s "Arrui" "data/Applications/accelerate.app/accelerate" . 2>&1`

if [ "$?" -ne "0" ]; then
	echo "codesign Failed"
fi

cd "$data_dir"

# --------------------------------------
find . -name .svn -exec rm -rf {} \;
find . -name *DS_Store* -exec rm -f {} \;
info=`tar czvf ../data.tar.gz --exclude "./.?*" . 2>&1`
if [ "$?" -ne "0" ]; then
	echo "archive data.tar.gz failed"
fi

# --------------------------------------

cd ..


cd "$control_dir"
# --------------------------------------
info=`tar czvf ../control.tar.gz --exclude "./.?*" . 2>&1`# >/dev/null
if [ "$?" -ne "0" ]; then
	echo "archive control.tar.gz failed"
fi
# --------------------------------------
cd ..


info=`ar -q "$output_dir/$package_name.deb" debian-binary control.tar.gz data.tar.gz 2>&1`
if [ "$?" -ne "0" ];then
	echo "create deb pkg failed"
fi
