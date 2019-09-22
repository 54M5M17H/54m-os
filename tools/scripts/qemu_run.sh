#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR
qemu-system-x86_64 -monitor stdio -fda ../../boot.bin
