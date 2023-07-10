# custom command to work & build from the same dir
# e.g. $NS3DIR/scratch
waff() {
    CWD="${NS3LOGDIR}"
    cd $NS3DIR >/dev/null
    ./waf --cwd="$CWD" $*
    cd - >/dev/null
}
