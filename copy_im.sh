#!/bin/sh
set -e -x
###################################################
# copy images from several subfolder to one folder
###################################################

usage ()
{
    echo "use:"
    echo "./copy_im <src> <dest>"
    echo ""
    exit 1
}

if [ -z $2 ]; then
    usage
fi

SRC=`pwd`/$1
DES=`pwd`/$2


if [ ! -d $DES -o ! -d $SRC ]; then
    echo "destination does not exist"
    exit 1;
fi

for ext in jpg, JPG, jpeg, JPEG
do
    echo $ext
    for i in `find $SRC -name "*.${ext}"`
    do
	cp -n $SRC/$i $DES;
	echo "copying $SRC/$i to $DES ...\n"
    done
done

if [ -d $DES ]; then 
    NUM=`ls $DEST | wc -l`
    echo  "----------------------------------------------"
    echo  "$NUM files copied\n"
fi

exit 0
