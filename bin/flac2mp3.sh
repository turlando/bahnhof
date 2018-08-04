#!/bin/sh
set -eu

##
## NAME
##        flac2mp3 - covert a FLAC file into MP3
##
## SYNOPSIS
##        flac2mp3 -d DIRECTORY -f SOURCE
##
## DESCRIPTION
##        Convert a FLAC file into an MP3 file and translates the OggVorbis
##        metadata into ID3v2 tags.  A destination folder must be specified
##        and the MP3 file is renamed using the format ARTIST - TITLE.mp3.
##
##        Requires ffmpeg and ffprobe to be in the PATH.
##
##        -d, --dest-dir
##               Destination folder the MP3 will be copied into
##
##        -f, --source-file
##               Source FLAC file to be converted
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
        -d|--dest-dir)
            DEST_DIR="${2:-}"
            shift
            ;;

        -f|--source-file)
            SOURCE_FILE="${2:-}"
            shift
            ;;

        *)
            break
            ;;
    esac

    shift
done

# Die if DEST_DIR is not provided.
if [ -z "${DEST_DIR:-}" ]; then
    exit 1
fi

# Die if SOURCE_FILE is not provided.
if [ -z "${SOURCE_FILE:-}" ]; then
    exit 1
fi

ARTIST=$(ffprobe                                    \
             -loglevel error                        \
             -show_entries format_tags=artist       \
             -of default=noprint_wrappers=1:nokey=1 \
             "${SOURCE_FILE}")

TITLE=$(ffprobe                                    \
            -loglevel error                        \
            -show_entries format_tags=title        \
            -of default=noprint_wrappers=1:nokey=1 \
            "${SOURCE_FILE}")

DEST_FILE="${DEST_DIR}/${ARTIST} - ${TITLE}.mp3"

ffmpeg                  \
    -i "${SOURCE_FILE}" \
    -ab 320k            \
    -map_metadata 0     \
    -id3v2_version 3    \
    "${DEST_FILE}"

exit 0
