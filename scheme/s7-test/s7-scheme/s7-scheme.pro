TEMPLATE = app
CONFIG += console
CONFIG -= qt
QMAKE_CXXFLAGS += -Wno-unused-parameter

SOURCES += main.cpp
LIBS += -lreadline -lhistory

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../s7/release/ -ls7
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../s7/debug/ -ls7
else:symbian: LIBS += -ls7
else:unix: LIBS += -L$$OUT_PWD/../s7/ -ls7

INCLUDEPATH += $$PWD/../s7
DEPENDPATH += $$PWD/../s7

win32:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../s7/release/s7.lib
else:win32:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../s7/debug/s7.lib
else:unix:!symbian: PRE_TARGETDEPS += $$OUT_PWD/../s7/libs7.a

unix: CONFIG += link_pkgconfig
unix: PKGCONFIG += glibmm-2.4
