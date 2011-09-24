#!/bin/bash
set -e
set -u
./postgresql.SlackBuild || exit $?
