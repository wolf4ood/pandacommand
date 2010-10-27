#!/bin/sh

valac --pkg   gmodule-2.0  --pkg libsoup-2.4 --pkg gee-1.0  --pkg gstreamer-0.10 -C PandaGuess.vala ../../src/PandaPlugin.vala
gcc -shared -fPIC $(pkg-config --cflags --libs glib-2.0 gmodule-2.0 gee-1.0 libsoup-2.4 ) -o libpandaguess.so PandaGuess.c PandaPlugin.c
