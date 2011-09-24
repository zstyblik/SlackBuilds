#!/bin/bash
set -e
set -u
./apcupsd.SlackBuild || exit $?
