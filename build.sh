#!/bin/bash
set -e

function help ()
{
    echo "build.sh [option] [source]"
    echo "    options:      "
    echo "        -l|--library     list of libraries separated by blank space"
    echo "        -s|source        source file"
    echo "        -h|help          print help"
    echo "        no option        build of [source] will run with default fty libraries"

}

function isSource ()
{
    echo "${1}" | grep -q ".c" || \
    echo "${1}" | grep -q ".cc" || \
    echo "${1}" | grep -q ".cpp"
    return $?
}

function isCXX ()
{
    echo "${1}" | grep -q ".cc" || \
    echo "${1}" | grep -q ".cpp"
    return $?

}

DEFLIBS="-lcxxtools -lczmq -ltntdb -lmlm"

while [[ "${#}" -gt 0 ]];
do
    case ${1} in
        -l|--library)
            if [ ${3} != "-s" ]; then
                while [ ${2} != "-s"  ] && [ ${2} != "--source" ]; do
                    LIBS+="-l$2 "
                    shift
                done
                shift
                echo ${LIBS}
                echo ${2}
            else
                shift
                shift
            fi

            continue
            ;;
        -s|--source)
            SRC=$2
            shift
            shift
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        --)
	    shift
	    break
	    ;;
	*)
            if  isSource ${1} ; then
                SRC=${1}
                LIBS=DEFLIBS
                break
            fi
	    echo "Unknown parameter ${1}"
	    exit 1
	    ;;
	esac
done

IAM=`pwd`

# am I c++ code?
if  isCXX ${SRC}; then
    EXT=3;
else
    # assuming .c here
    EXT=2
fi

LEN=${#SRC}
OUT=${SRC:0:$LEN-$EXT} # substr

# remove binary
if [ -e $IAM/$OUT ]; then
    rm $IAM/$OUT
fi

# compile
if [ $EXT -eq 3 ]; then
    g++ -std=c++11 $IAM/$SRC -Werror -Wall -Weffc++ ${LIBS}  -o $IAM/$OUT && $IAM/$OUT
fi

if [ $EXT -eq 2 ]; then
    gcc -std=c99 -D_SVID_SOURCE -Werror -D_POSIX_C_SOURCE -ggdb ${LIBS}  $IAM/$SRC -o $IAM/$OUT && $IAM/$OUT
fi

exit 0
