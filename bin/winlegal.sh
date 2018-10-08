#!/bin/sh
set -eu

##
## NAME
##        winlegal - find illegal Windows files and directories
##
## SYNOPSIS
##        winlegal -d DIRECTORY
##
## DESCRIPTION
##        Show a list of files in DIRECTORY that are not visible to Windows.
##
##        -d, --dir
##               Base directory.
##

# Die if no arguments are provided.
if [ $# -eq 0 ]; then
    exit 1
fi

# Loop over arguments
while :; do

    # Once it has reached the last argument $1 is unset.
    # The following expansion will result in an empty string
    # if $1 is unset to avoid dereferencing unset variables.
    # Same design is applied for $2.
    case "${1:-}" in
        -d|--dir)
            DIR="${2:-}"
            shift
            ;;

        *)
            break
            ;;
    esac

    shift
done

find "${DIR}" -name '*[<>:\\|?*]*'

exit 0
