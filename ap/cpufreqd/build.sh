#!/bin/bash
set -e
set -u
./cpufreqd.SlackBuild || exit $?
