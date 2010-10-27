#!/bin/bash 

valac --pkg   gmodule-2.0 --pkg gee-1.0 --pkg libsoup-2.4 --pkg json-glib-1.0 -C PandaTorrent.vala ../../src/PandaPlugin.vala 
gcc -shared -fPIC $(pkg-config --cflags --libs glib-2.0 gee-1.0 gmodule-2.0 libsoup-2.4 json-glib-1.0) -o libpandatorrent.so PandaPlugin.c PandaTorrent.c
