#!/bin/bash

set -e

SRC="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CEMUDIR=$HOME/cemu

mkdir -p $SRC/build

pushd $SRC/build &> /dev/null
cmake ..
make -j10
popd &> /dev/null

pushd $CEMUDIR &> /dev/null
export KOKU_XINPUT_DEBUG=1
export LD_PRELOAD="$SRC/build/koku-xinput-wine.so $SRC/build/koku-xinput-wine64.so"
wine Cemu.exe
popd &> /dev/null
