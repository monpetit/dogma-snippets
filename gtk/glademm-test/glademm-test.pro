TEMPLATE = app
CONFIG -= qt bundle

SOURCES += main.cpp
QMAKE_CFLAGS += -export-dynamic

unix: CONFIG += link_pkgconfig
unix: PKGCONFIG += gtkmm-2.4 gmodule-2.0

OTHER_FILES += \
    main_window.glade
