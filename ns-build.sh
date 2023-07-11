#!/bin/bash
# build command for modern versions (3.36 and later)
$NS3DIR/ns configure --enable-examples --enable-tests \
                    --build-profile=debug --out=build/debug && \
$NS3DIR/ns -j 2 build
