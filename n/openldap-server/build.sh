#!/bin/bash
set -e
set -u
./openldap-server.SlackBuild || exit $?
