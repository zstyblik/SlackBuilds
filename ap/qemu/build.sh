#!/bin/bash
set -e
set -u
./qemu.SlackBuild || exit $?
