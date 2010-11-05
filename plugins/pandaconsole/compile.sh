#!/bin/sh

valac --thread --pkg   gmodule-2.0 --pkg gee-1.0 --pkg libsoup-2.4  -C PandaConsole.vala ../../src/PandaPlugin.vala
gcc -shared -fPIC $(pkg-config --cflags --libs glib-2.0 gmodule-2.0  gee-1.0 libsoup-2.4) -o libpandaconsole.so PandaConsole.c   PandaPlugin.c
