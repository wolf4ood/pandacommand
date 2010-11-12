#!/bin/sh

valac  -g --save-temps -v --thread --pkg   gmodule-2.0 --pkg   json-glib-1.0  --pkg gee-1.0  --pkg libsoup-2.4 --pkg gstreamer-0.10  src/*.vala src/pandaconsole/*.vala src/pandaconnect/*.vala -o pandacommand
