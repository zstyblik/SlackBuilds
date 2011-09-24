#!/bin/bash
set -e
set -u
./qemu-kvm.SlackBuild || exit $?
