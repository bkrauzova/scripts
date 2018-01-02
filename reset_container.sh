#!/bin/sh

CPATH=/home/lxc
CONT=42ity
IMG=devel
VERSION=$1
DATE=$2
NUM=$3

usage() {
    echo "Help "
    echo "sudo ./reset_container.sh [image version] [date of the build] [number of image]"
    echo
    echo "example: [image version] 20.54.01, [date of the build] 16.10.20 yy.mm.dd, [number of image] 2"
}

runContainer ()
{
    echo -ne "\tStaring $CONT\n"
    /bin/virsh -c lxc:/// start $CONT
    /bin/virsh -c lxc://
    sleep 2
}

if [ -z $VERSION ]; then
    echo "Version is missing."
    usage
    exit 1
fi

if [ -z $DATE ]; then
    DATE=$(/bin/date +"%y.%m.%d")
fi

if [ -z $NUM ]; then
    NUM=1
fi

TODOWN=fty-devel-image-$DATE-$VERSION+${NUM}_x86_64.tar.gz

echo "* Updating container" \'$CONT\'

# remove old image
/bin/rm -Rf $CPATH/fty-devel-image-* 2>/dev/null
/bin/rm -Rf $CPATH/$CONT/* 2>/dev/null
sleep 2

# get new one
/bin/wget http://tomcat.roz.lab.etn.com/images/fty-devel-image/master/x86_64/fty-devel-image-$DATE-$VERSION+${NUM}_x86_64.tar.gz -P $CPATH/ 
sleep 2


if [ -e $CPATH/fty-devel-image-$DATE-$VERSION+${NUM}_x86_64.tar.gz ]; then
    # extract
    /bin/tar -xz -C $CPATH/$CONT -f $CPATH/$TODOWN
    echo "* Container updated *  "
    runContainer    
else 
    echo "- Image not downloaded - "
    usage
    exit 1
fi

exit 0
