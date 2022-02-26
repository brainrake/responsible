#!/bin/sh
set -e
./build.sh && build/exec/hello
# ./build.sh && exec node --inspect build/exec/hello
