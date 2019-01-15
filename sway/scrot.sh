#!/bin/sh
set -eu

##
## NAME
##        scrot - take a screenshot
##
## SYNOPSIS
##        scrot [-r]
##
## DESCRIPTION
##        -r
##               Select region before taking screenshot
##

FILE="/tmp/screenshot_$(date +%Y-%m-%d_%H:%M:%S).png"

if [ "${1:-}" = "-r" ]; then
    slurp | grim -g - ${FILE}
else
    grim "${FILE}"
fi

exit 0
