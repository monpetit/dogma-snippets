TEMPLATE = lib
CONFIG += console staticlib
CONFIG -= qt
QMAKE_CFLAGS += -Wno-unused-parameter

SOURCES += \
    s7.c

HEADERS += \
    mus-config.h \
    s7.h

