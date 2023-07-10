PATH="/opt:$PATH"
# set env var for ns-3 base path
DISTDIR=/code
NS3DIR=${DISTDIR}/ns-3
NS3LOGDIR=${HOME}/ns-3/build/log
# utility env vars
NS3CONFIG="--enable-examples --enable-tests"
NS3DEBUG="--build-profile=debug --out=build/debug"
NS3OPT="--build-profile=optimized --out=build/optimized"
