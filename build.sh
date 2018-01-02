#!/bin/bash
set -e

SRC=$1

usage ()
{
    echo "build <source.ext>"
    echo "ext=c/c++"
}

if [ -z $SRC ]; then
    echo -e "source file missing...\n"
    usage
    exit 1
fi

# am I c++ code?
if  echo $SRC | grep -q ".cc" ; then
    EXT=3;
else
    # assuming .c here
    EXT=2
fi

LEN=${#SRC}
OUT=${SRC:0:$LEN-$EXT} # substr

if [ -e $OUT ]; then
    rm $OUT
fi

if [ $EXT -eq 3 ]; then
    g++ -std=c++11 $SRC -lcxxtools -lczmq -ltntdb  -o $OUT && ./$OUT
fi

if [ $EXT -eq 2 ]; then
    gcc -std=c99 -D_SVID_SOURCE -Werror -ggdb -lczmq -lmlm $SRC -o $OUT && ./$OUT
fi

exit 0
