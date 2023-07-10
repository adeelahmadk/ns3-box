#!/bin/bash

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

version_major()
{
    echo ${1%.*}
}

version_minor()
{
    echo ${1##*.}
}

[ "$#" -gt 1 ] && { usage; exit 1; }
[ "$#" -eq 1 -a "$1" = "-h" ] && { usage; exit 0; }

if [[ $1 =~ $rx ]]; then
    version="$1"
    major=$(version_major "$*")
    minor=$(version_minor "$*")
    if [ "$major" -eq 3 -a "$minor" -ge 30 -a "$minor" -le 35 ]; then
        NS3VERSION="$1"
    else
        NS3VERSION="3.35"
else
    NS3VERSION="3.35"
fi

cd ${DISTDIR}
[ "$(ls -A)" ] && { echo "Not empty, cleaning up!"; rm -rf $(ls -A); }

# make download link to the required release archive
dl_link="https://www.nsnam.org/releases/ns-allinone-${NS3VERSION}.tar.bz2"
outfile="ns-${NS3VERSION}.tar.bz2"

# download ns3 distribution if not already there
if [[ ! -f "$outfile" ]]; then curl -o "$outfile" "$dl_link"; fi
# extract the archive to DISTDIR
tar xf "$outfile" -C . --strip-components 1 && rm "$outfile"

# symlink ns3 dir to "ns-3"
nsdir=${DISTDIR}/$(<.config hxselect -c "ns-3::attr(dir)")
ln -fs ${nsdir} ns-3

# create necessary dir tree
mkdir -p ${nsdir}/build/debug/scratch && \
mkdir -p ${nsdir}/build/optimized/scratch && \
mkdir -p ${nsdir}/build/log && \
rm -r ${nsdir}/scratch/*

# build netanim
cd ${DISTDIR}/$(<.config hxselect -c "netanim::attr(dir)") && \
  qmake NetAnim.pro && make && cd ${DISTDIR}

# uncomment the add-on components you want to include
# hg clone http://code.nsnam.org/BRITE && \
# cd BRITE && make && cd ${DISTDIR}

# git clone https://github.com/kohler/click && \
# cd click && \
# ./configure --disable-linuxmodule --enable-nsclick --enable-wifi && \
# make && cd doc && make install-man && make install && \
# cd ${DISTDIR}

# cd - >/dev/null
