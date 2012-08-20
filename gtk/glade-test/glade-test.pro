TEMPLATE = app
CONFIG -= qt bundle

SOURCES += main.c
QMAKE_CFLAGS += -export-dynamic -Wno-unused-parameter

unix: CONFIG += link_pkgconfig
unix: PKGCONFIG += gtk+-2.0 gmodule-2.0
