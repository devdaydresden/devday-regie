#!/bin/sh

/usr/bin/Xvfb :0 -screen 0 1680x1050x24 -dpi 72 &
export DISPLAY=:0
(
	sleep 30;
	~/configure-session.sh
) &
/usr/bin/pulseaudio --start
/usr/bin/mate-session
