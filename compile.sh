#!/bin/sh

valac  -v --pkg   gmodule-2.0 --pkg   json-glib-1.0  --pkg gee-1.0  --pkg libsoup-2.4 --pkg gstreamer-0.10 -C src/*.vala 
