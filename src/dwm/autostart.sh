#!/usr/bin/env sh
amixer set Master 0
slstatus &
picom --config /usr/share/doc/picom/examples/picom.sample.conf &
nm-applet&
dunst &
~/.fehbg
