#!/bin/sh
set -eu

##
## NAME
##        ec - start emacsclient
##

emacsclient --create-frame --no-wait "$@"

exit 0
