#!/bin/bash

EXE=${1:-$HOME/cemu/Cemu.exe}

SRC="$(cd -P "$( dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -f "$EXE" ]; then
  echo "$EXE not found."
  exit 1
fi

set -e

mkdir -p $SRC/build

pushd $SRC/build &> /dev/null
cmake ..
make -j10
popd &> /dev/null

pushd $(dirname $EXE) &> /dev/null
if [ ! -f gamecontrollerdb.txt ]; then
  wget https://raw.githubusercontent.com/gabomdq/SDL_GameControllerDB/master/gamecontrollerdb.txt
fi

export KOKU_XINPUT_DEBUG=1
export LD_PRELOAD="$SRC/build/koku-xinput-wine.so $SRC/build/koku-xinput-wine64.so"
wine $(basename $EXE)
popd &> /dev/null
