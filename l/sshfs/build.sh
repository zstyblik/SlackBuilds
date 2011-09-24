#!/bin/bash
set -e
set -u
./sshfs.SlackBuild || { echo "SlackBuild failed."; exit $?; }
