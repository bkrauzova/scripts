#!/bin/bash


PATH42="/home/bstepankova/42ity-github"
LIBDIR="/usr/lib64"
HEADERDIR="/usr/include"

echo "args: $1 $2"
while [[ "${#}" -gt 0 ]];
do
    case ${1} in
        -l|--lib)
            LIB=$2
            break
            ;;
        -a|--all)
            shift
            shift
            ;;
        --)
	    shift
	    break
	    ;;
	*)
	    echo "Unknown parameter ${1}"
	    shift
	    ;;
	esac
done
echo " libr $LIB"

if [ -n "${LIB}" ]; then
    case ${LIB} in
        db)
            LIB="fty_common_db"
            FOLDER="fty-common-db"
            ;;
        common)
            LIB="fty_common"
            FOLDER="fty-common"
            ;;
        mlm)
            LIB="fty_common_mlm"
            FOLDER="fty-common-mlm"
            ;;
        log|logging)
            LIB="fty_common_logging"
            FOLDER="fty-common-logging"
            ;;
        proto)
            LIB="fty_proto"
            FOLDER="fty-proto"
            ;;
	*)
	    echo "Unknown library ${LIB}"
	    shift
	    ;;
    esac

fi

remove_lib () {

    for sub in  ".so" ".so.1" ".so.1.0.0" ".la" ".a"; do
#        /bin/rm ${LIBDIR}/${LIB}/${sub}
        echo ${LIBDIR}/lib${LIB}${sub}
    done

#    /bin/rm/ ${LIBDIR}/pkgconfig/${LIB}.pc
    echo ${LIBDIR}/pkgconfig/lib${LIB}.pc

    /bin/rm ${HEADERDIR}/${LIB}.h
    echo ${HEADERDIR}/${LIB}.h
    echo "removed"
}

update_repository () {
    if [  `pwd` -nq ${PATH42}/${FOLDER} ]; then
        cd ${PATH42}/${FOLDER}
    fi
    git checkout master
    git pull upstream master


}

install_lib () {
    cd ${PATH42}/${FOLDER}
    ./autogen.sh && \
    ./configure --with-docs=no --prefix=/usr --libdir=/usr/lib64  && \
    make && \
    make install

    echo "${LIB} installed"
}


remove_lib
update_repository
install_lib
