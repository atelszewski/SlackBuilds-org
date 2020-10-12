#!/bin/bash

set -e
set -u
set -o pipefail

source $(pwd)/*.info

sftpuser=atelszewski
sftphost=web.sourceforge.net
sftpopt=(-o PasswordAuthentication=no)
destdir=/home/frs/project/slackbuildsdirectlinks/${PRGNAM}

sftp "${sftpopt[@]}" ${sftpuser}@${sftphost} << EOF
   mkdir ${destdir}
   cd ${destdir}
   put ${PRGNAM}-${VERSION}.tar.gz
   put ${PRGNAM}-${VERSION}.tar.gz.md5
EOF
