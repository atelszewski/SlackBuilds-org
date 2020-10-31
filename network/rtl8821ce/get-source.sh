#!/bin/bash

set -e
set -u
set -o pipefail

giturl=https://github.com/tomaspinho/rtl8821ce.git
destdir=rtl8821ce
branch=master
commit=ca204c6

umask 022

cwd=$(pwd)

if [[ -e ${destdir} ]]; then
    cd ${destdir}

    git checkout ${branch}
    git pull
else
    git clone --recursive ${giturl} ${destdir}

    cd ${destdir}
fi

git checkout ${commit}

version=$(git log -1 --format=%cd_%h --date=format:%Y%m%d)
srcdate=$(git log -1 --format=%at)

srcname=${destdir}-${version}
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
