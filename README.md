# A Docker Container for NS3 Development Environment

An [NS3](https://www.nsnam.org/) development environment in a docker container based on ubuntu jammy x86_64.

## Dockerfile

There are two Dockerfile configurations available in this distro to cover versions as old as 3.30. Use `ns3_3.30-3.35.dockerfile` to build an image for versions number 3.30 to 3.35 and `ns3_3.36p.dockerfile` to build an image for 3.36 and higher versions.

## Environment Setup

A bash script `ns3env.sh` is appended to the `.bashrc` file to make distribution directories and build process easily accessible:

```bash
PATH="/opt:$PATH"
# set env var for ns-3 base path
DISTDIR=/code
NS3DIR=${DISTDIR}/ns-3
NS3LOGDIR=${HOME}/ns-3/build/log
# utility env vars
NS3CONFIG="--enable-examples --enable-tests"
NS3DEBUG="--build-profile=debug --out=build/debug"
NS3OPT="--build-profile=optimized --out=build/optimized"
```

A custom command is also added to work and build from the same dir (e.g. $NS3DIR/scratch)
```bash
waff() {
    CWD="${NS3LOGDIR}"
    cd $NS3DIR >/dev/null
    ./waf --cwd="$CWD" $*
    cd - >/dev/null
}
```

## Building image

```bash
docker build -f ns3_3.36p.dockerfile -t ns3-box:jammy3.36plus .
```

## Spin up a Container

A local directory, to store the NS3 distribution, should be mounted as a volume on to `/code` in the container.
```bash
docker container run \
    --rm -it \
    --name="ns3.test" \
    --volume="./dist:/code:rw" \
    ns3-box:jammy3.36plus \
    /bin/bash
```

### Distribution Download

A bash script `get-ns` to download the latest (or any) verion of NS3 is placed on the `PATH` in the container. The user should run it to setup the NS3 distribution on the mounted volume. Finally, the distribution can be built using `waf` or `ns3` python script depending on the distro version.
