#-------------------------------------------------
#
# Project created by QtCreator 2011-07-17T11:43:14
#
#-------------------------------------------------

QT       += core sql network xmlpatterns webkit gui

TARGET = MeeBible2
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app


SOURCES += main.cpp \
    TranslationsList.cpp \
    Language.cpp \
    Translation.cpp \
    ChapterRequest.cpp \
    Source.cpp \
    NWTSource.cpp \
    NWTranslation.cpp \
    NWTChapterRequest.cpp \
    BibleView.cpp

HEADERS += \
    TranslationsList.h \
    Language.h \
    Translation.h \
    ChapterRequest.h \
    Source.h \
    NWTSource.h \
    NWTranslation.h \
    NWTChapterRequest.h \
    BibleView.h

RESOURCES += \
    MeeBible2.qrc

OTHER_FILES += \
    createlangs.sql \
    createnwt.sql \
    nwt.xslt \
    style.css
