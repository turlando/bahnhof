#!/bin/sh
set -eu

##
## NAME
##        mpctl - Control MPRIS-enabled players
##
## SYNOPSIS
##        mpctl OPTIONS
##
## DESCRIPTION
##        Issue commands to the default MPRIS player.
##
##        Available options:
##
##        p|play|pause
##               Pause or resume playback
##
##        n|next
##               Skip to next track
##
##        b|prev|previous
##               Skip to previous track
##
##        s|stop
##               Stop playback
##


# Die if no arguments are provided.
if [ $# -eq 0 ]; then
    exit 1
fi

case "${1:-}" in
    p|play|pause)
        COMMAND="PlayPause"
        ;;
    n|next)
        COMMAND="Next"
        ;;
    b|prev|previous)
        COMMAND="Previous"
        ;;
    s|stop)
        COMMAND="Stop"
        ;;
    *)
        exit 1
        ;;
esac

dbus-send                                      \
    --session                                  \
    --print-reply                              \
    --dest=org.mpris.MediaPlayer2.quodlibet    \
    /org/mpris/MediaPlayer2                    \
    "org.mpris.MediaPlayer2.Player.${COMMAND}" \
    &>/dev/null

exit 0
