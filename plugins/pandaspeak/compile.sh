#!/bin/sh

valac --pkg   gmodule-2.0 --pkg gee-1.0 --pkg posix  -C PandaSpeak.vala ../../src/PandaPlugin.vala
gcc -shared -fPIC $(pkg-config --cflags --libs glib-2.0 gmodule-2.0  gee-1.0 ) -o libpandaspeak.so PandaSpeak.c   PandaPlugin.c
