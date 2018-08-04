#!/bin/sh
set -eu

##
## NAME
##        flacstripart - remove cover art from FLAC files
##
## SYNOPSIS
##        flacstripart ([-r] -d DIRECTORY | -f FILE)
##
## DESCRIPTION
##        Remove the embedded cover art from a FLAC file.
##
##        Requires metaflac to be in the PATH.
##
##        -f, --file
##               The FLAC file
##               Cannot be used with --directory
##
##        -d, --directory
##               Directory containing the FLAC files
##               Cannot be used with --file
##
##        -r, --recursive
##               If --directory is specified it will also check FLAC files
##               in its subdirectories
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
        -f|--file)
            FILE="${2:-}"
            shift
            ;;

        -d|--directory)
            DIRECTORY="${2:-}"
            shift
            ;;

        -r|--recursive)
            WANT_RECURSION=true
            ;;

        *)
            break
            ;;
    esac

    shift
done

# Die if FILE and DIRECTORY are not provided.
if [ -z "${FILE:-}" ] && [ -z "${DIRECTORY:-}" ]; then
    exit 1
fi

# Die if FILE and DIRECTORY are both provided.
if [ ! -z "${FILE:-}" ] && [ ! -z "${DIRECTORY:-}" ]; then
    exit 1
fi

if [ ! -z "${FILE:-}" ]; then
    metaflac                 \
        --remove             \
        --block-type=PICTURE \
        "${FILE}"
    metaflac                  \
        --remove-tag=COVERART \
        "${FILE}"
    exit 0
fi

if [ ! -z "${DIRECTORY:-}" ]; then

    # If --recursive is not specified.
    if [ -z ${WANT_RECURSION:-} ]; then

        for F in "${DIRECTORY}"/*.flac; do
            metaflac                 \
                --remove             \
                --block-type=PICTURE \
                "${F}"
            metaflac                  \
                --remove-tag=COVERART \
                "${F}"
        done

        exit 0

    # If --recursive is specified.
    else
        find "${DIRECTORY}" \
             -name '*.flac' \
             -exec  metaflac --remove --block-type=PICTURE {} \; \
             -exec  metaflac --remove-tag=COVERART {} \;
        exit 0

    fi

fi

exit 0
