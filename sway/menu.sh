#!/bin/sh
set -eu

##
## NAME
##        menu - wrapper around dmenu
##
## SYNOPSIS
##        menu [-r]
##
## DESCRIPTION
##        The stdin is redirected to dmenu.
##
##        -r
##               Run dmenu_run instead of dmenu
##

HEIGHT=20
FONT='Lato Medium-9'
PROMPT=''
NORMAL_BACKGROUND='#383C4A'
SELECT_BACKGROUND='#5294E2'
NORMAL_TEXT='#D3DAE3'
SELECT_TEXT='#FFFFFF'

CMD=$(if [ "${1:-}" = "-r" ]
      then echo "dmenu_run"
      else echo "dmenu"
      fi)

${CMD} -b -i                      \
       -h  "${HEIGHT}"            \
       -fn "${FONT}"              \
       -p  "${PROMPT}"            \
       -nb "${NORMAL_BACKGROUND}" \
       -sb "${SELECT_BACKGROUND}" \
       -nf "${NORMAL_TEXT}"       \
       -sf "${SELECT_TEXT}"       \
       <&0

exit 0
