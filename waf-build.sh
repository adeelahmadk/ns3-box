#!/bin/bash
# build command for legacy versions (3.30-3.35)
$NS3DIR/waf configure $NS3CONFIG $NS3DEBUG && \
$NS3DIR/waf -j 2 build
