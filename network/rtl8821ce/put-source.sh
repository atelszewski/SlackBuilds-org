#!/bin/bash

set -e
set -u
set -o pipefail

source $(pwd)/*.info

sftpuser=atelszewski
sftphost=web.sourceforge.net
sftpopt=(-o PasswordAuthentication=no)
destdir=/home/frs/project/slackbuildsdirectlinks/${PRGNAM}

if ! [[ -e ${PRGNAM}-${VERSION}.tar.gz.md5 ]]; then
    md5sum ${PRGNAM}-${VERSION}.tar.gz > ${PRGNAM}-${VERSION}.tar.gz.md5
fi

sftp "${sftpopt[@]}" ${sftpuser}@${sftphost} << EOF
    mkdir ${destdir}
    cd ${destdir}
    put ${PRGNAM}-${VERSION}.tar.gz
    put ${PRGNAM}-${VERSION}.tar.gz.md5
    put get-source.sh ${PRGNAM}-${VERSION}-get-source.sh
EOF
