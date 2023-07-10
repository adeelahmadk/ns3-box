#!/bin/bash
# build command for modern versions (3.36 and later)
$NS3DIR/ns configure $NS3CONFIG $NS3DEBUG && \
$NS3DIR/ns -j 2 build
