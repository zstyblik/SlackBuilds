#!/bin/bash
set -e
set -u
./sshfs-fuse.SlackBuild || { echo "SlackBuild failed."; exit $?; }
