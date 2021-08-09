#!/bin/bash

set -e
set -u
set -o pipefail

prgnam=vdo
version=6.2.5.65_COPR
commit=6.2.5.65-COPR
giturl=https://github.com/rhawalsh/vdo.git

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
