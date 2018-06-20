TEMPLATE = app
CONFIG += console
CONFIG -= app_bundle
CONFIG -= qt

SOURCES += main.c \
    Core.c \
    scenes/Scene.c \
    scenes/SceneManager.c \
    scenes/intro/Intro.c \
    utils/file_utils.c \
    asm/crt0.s \
    assets/scenes/intro/intro_la.s \
    assets/scenes/intro/intro_la_screendata.s \
    assets/scenes/intro/intro_la_table.s \
    utils/screen_utils.c

HEADERS += \
    Core.h \
    Core.h \
    scenes/Scene.h \
    scenes/SceneManager.h \
    scenes/intro/Intro.h \
    utils/lz48decrunch.h \
    utils/lz48decrunch.h \
    utils/screen_utils.h

DISTFILES += \
    Makefile \
    utils/lz48decrunch.s \
    utils/lz48decrunch.s

INCLUDEPATH += \
            . \
            scenes \
            utils
