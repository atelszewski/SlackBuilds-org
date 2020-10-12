#!/bin/bash

# Copyright 2021 Andrzej Telszewski, Copenhagen
# All rights reserved.
#
# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

set -e
set -u
set -o pipefail

prgnam=qt-creator-llvm
version=
commit=f37d80d0f6c78e97a34fc8e2e81562ea492af00d
giturl=git://code.qt.io/clang/llvm-project.git

destdir=/tmp/SBo-git-sources/${prgnam}
srcdir=${prgnam}

umask 022

cwd=$(pwd)

if [[ -e ${destdir}/${srcdir} ]]; then
    cd ${destdir}/${srcdir}

    git fetch
else
    git clone --recurse-submodules ${giturl} ${destdir}/${srcdir}

    cd ${destdir}/${srcdir}
fi

git checkout ${commit}

version=${version:-$(git log -1 --format=%cd_%h --date=format:%Y%m%d)}
srcdate=$(git log -1 --format=%at)

srcname=${srcdir}-${version}
tarname=${srcname}.tar.gz

# Create reproducible tarball.
# Last commit date is used to set common date for all files.
# Dir and tarball name and version are obtained using _transform=_.

tar --verbose                                                                \
    --no-acls --no-selinux --no-xattrs                                       \
    --exclude-vcs-ignores --exclude-vcs --exclude=\*/.github\*               \
    --sort=name --transform="s/^\.\//${srcname}\//" --show-transformed-names \
    --owner=0 --group=0 --numeric-owner                                      \
    --mtime=@${srcdate}                                                      \
    --create --file - .                                                      \
    | gzip -9 -cn > ${cwd}/${tarname}

cd ${cwd}
md5sum ${tarname} > ${tarname}.md5
cat ${tarname}.md5
