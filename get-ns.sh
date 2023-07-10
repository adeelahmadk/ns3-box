#!/bin/bash

# set env var for ns-3 base path
DISTDIR=/code
NS3DIR=${DISTDIR}/ns-3
NS3LOGDIR=${HOME}/ns-3/build/log
# utility env vars
NS3CONFIG="--enable-examples --enable-tests"
NS3DEBUG="--build-profile=debug --out=build/debug"
NS3OPT="--build-profile=optimized --out=build/optimized"

# vars for ns3 download
outfile=
dl_link=
# regex to check version number format
rx='^([0-9]+\.){0,1}(\*|[0-9]+)$'

usage()
{
    echo "usage: `basename $0` [version]  `basename $0` [-h]
    Get, extract and build the NS3 distribution. Optional argument is the
    version number. In case the script is run without this argument then
    it'll download the latest version available.

    Option:
      -h   Print this help"
}

# get major from given version number
version_major()
{
    echo ${1%.*}
}

# get minor from given version number
version_minor()
{
    echo ${1##*.}
}

# early exit cases
[ "$#" -gt 1 ] && { usage; exit 1; }
[ "$#" -eq 1 -a "$1" = "-h" ] && { usage; exit 0; }

# verify version number arg
if [[ $1 =~ $rx ]]; then
    version="$1"
    major=$(version_major "$*")
    minor=$(version_minor "$*")
    if [ "$major" -eq 3 -a "$minor" -ge 36 ]; then
        NS3VERSION="$1"
    else
        NS3VERSION="latest"
    fi
else
    NS3VERSION="latest"
fi

# pull latest version number
if [[ "$NS3VERSION" = "latest" ]]; then
    # find the latest release
    selector="ul.side-nav:nth-child(2) > li:nth-child(1) > a:nth-child(1)"
    release=$(curl -s "https://www.nsnam.org/releases/" \
                | hxnormalize -x \
                | hxselect -c "$selector" \
                | cut -d'-' -f2)
# use the version number from arg.
else
    release="$NS3VERSION"
fi

# make download link to the required release archive
dl_link="https://www.nsnam.org/releases/ns-allinone-${release}.tar.bz2"
outfile="ns-${release}.tar.bz2"

echo "working in $DISTDIR"

if [ ! $(find . -maxdepth 1 -type d -name 'ns-3.3*') ]; then
    # download ns3 distribution only if not already there
    if [[ ! -f "$outfile" ]]; then curl -o "${outfile}" "${dl_link}"; fi
    tar xf "${outfile}" -C . --strip-components 1 && rm "${outfile}"
fi

# symlink ns3 dir to "ns-3"
nsdir="$DISTDIR"/$(<.config hxselect -c "ns-3::attr(dir)")
echo "creating symbolic link to $nsdir ..."
ln -fs "${nsdir}" ns-3

# create necessary dir tree
mkdir -p "${nsdir}/build/debug/scratch" && \
mkdir -p "${nsdir}/build/optimized/scratch" && \
mkdir -p "${nsdir}/build/log" && \
[ $(ln -A "${nsdir}/scratch/*") ] && rm -r "${nsdir}/scratch/*"

# if not already built
if [ ! $(find . -maxdepth 2 -type f -name 'NetAnim') ]; then
    # build netanim
    cd "${DISTDIR}/$(<.config hxselect -c "netanim::attr(dir)")" && \
    qmake NetAnim.pro && make && cd "${DISTDIR}"
fi

# uncomment the add-on components you want to include
# pull and build BRITE
# hg clone http://code.nsnam.org/BRITE && \
# cd BRITE && make && cd "${DISTDIR}"

# pull and build click distro
# git clone https://github.com/kohler/click && \
# cd click && \
# ./configure --disable-linuxmodule --enable-nsclick --enable-wifi && \
# make && cd doc && make install-man && make install && \
# cd "${DISTDIR}"

chown -R ns:ns .
