#!/bin/bash
set -e
set -u
./rrdtool.SlackBuild || exit $?
