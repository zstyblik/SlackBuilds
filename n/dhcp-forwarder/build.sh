#!/bin/bash
set -e
set -u
./dhcp-forwarder.SlackBuild || exit $?
