#!/bin/sh
xrandr                                                                          \
    --output LVDS1 --primary --mode 1600x900 --pos 320x1080 --rotate normal     \
    --output VGA1 --off                                                         \
    --output HDMI1 --off                                                        \
    --output HDMI2 --mode 1920x1080 --pos 0x0 --rotate normal --set "audio" on  \
    --output HDMI3 --off                                                        \
    --output DP1 --off                                                          \
    --output DP2 --off                                                          \
    --output DP3 --off                                                          \
    --output VIRTUAL1 --off
