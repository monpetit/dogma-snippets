#-------------------------------------------------
#
# Project created by QtCreator 2012-01-11T22:37:30
#
#-------------------------------------------------

QT       -= core gui

TARGET = guile-xmlreader
TEMPLATE = lib

DEFINES += GUILESO_LIBRARY

SOURCES += xmltext.cpp

HEADERS += xmltext.h

symbian {
    MMP_RULES += EXPORTUNFROZEN
    TARGET.UID3 = 0xE1ADE744
    TARGET.CAPABILITY =
    TARGET.EPOCALLOWDLLDATA = 1
    addFiles.sources = guile-so.dll
    addFiles.path = !:/sys/bin
    DEPLOYMENT += addFiles
}

unix:!symbian {
    maemo5 {
        target.path = /opt/usr/lib
    } else {
        target.path = /usr/lib
    }
    INSTALLS += target
}

unix: CONFIG += link_pkgconfig
unix: PKGCONFIG += libxml++-2.6
