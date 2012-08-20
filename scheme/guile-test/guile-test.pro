TEMPLATE = app
CONFIG += console
CONFIG -= qt
QMAKE_CXXFLAGS += -Wno-unused-parameter

SOURCES += main.cpp


unix: CONFIG += link_pkgconfig
unix: PKGCONFIG += glibmm-2.4 guile-2.0
