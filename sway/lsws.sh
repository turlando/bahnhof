#!/bin/sh
set -eu

##
## NAME
##        lsws - print sway workspaces
##
## CREDITS
##        Credits and kudos go to edne
##        https://github.com/edne/i3-workspace-handler
##

swaymsg -t get_workspaces | # get the json
tr ',' '\n'               | # replace commas with newline
grep name                 | # "name":"workspace-name"
cut -d '"' -f 4             #         ^ 4th field, spliting by "

exit 0
