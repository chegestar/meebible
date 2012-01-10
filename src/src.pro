TEMPLATE = app

QT += core sql network xml xmlpatterns webkit gui declarative

# DEFINES += DEBUGPATHS

nosearch:DEFINES += NOSEARCH
free:DEFINES += FREEVERSION

symbian {
    DEFINES += SYMBIAN

    free:DEFINES += INSTALLPREFIX=\"/meebible-free\"
    !free:DEFINES += INSTALLPREFIX=\"/meebible\"
}
else {
    free:DEFINES += INSTALLPREFIX=\\\"/opt/meebible-free\\\"
    !free:DEFINES += INSTALLPREFIX=\\\"/opt/meebible\\\"
}


TARGET = meebible
free:target.path = /opt/meebible-free/bin
!free:target.path = /opt/meebible/bin
INSTALLS += target



CONFIG += console
CONFIG += warn_on
CONFIG -= debug
CONFIG -= app_bundle


LIBS += -lsqlite3
!nosearch:LIBS += -licui18n

!symbian {
    CONFIG += qdeclarative-boostable
    INCLUDEPATH += /usr/include/applauncherd
    LIBS += -lmdeclarativecache
}


HEADERS +=                  \
    Language.h              \
    Languages.h             \
    Translation.h           \
    ChapterRequest.h        \
    Source.h                \
    NWTSource.h             \
    NWTranslation.h         \
    NWTChapterRequest.h     \
    BibleView.h             \
    Cache.h                 \
    Paths.h                 \
    Place.h                 \
    EasyXml.h               \
    BibleWebPage.h          \
    Fetcher.h               \
    Utils.h                 \
    Settings.h              \
    SimpleSource.h          \
    SimpleTranslation.h     \
    BLVSource2.h            \
    BOSource2.h             \
    CCArabicSource2.h       \
    KJBOSource.h

!nosearch:HEADERS +=        \
    SqliteUnicodeSearch.h   \
    SearchThread.h

SOURCES += main.cpp         \
    Language.cpp            \
    Languages.cpp           \
    Translation.cpp         \
    ChapterRequest.cpp      \
    Source.cpp              \
    NWTSource.cpp           \
    NWTranslation.cpp       \
    NWTChapterRequest.cpp   \
    BibleView.cpp           \
    Cache.cpp               \
    Paths.cpp               \
    Place.cpp               \
    EasyXml.cpp             \
    BibleWebPage.cpp        \
    Fetcher.cpp             \
    Settings.cpp            \
    SimpleSource.cpp        \
    SimpleTranslation.cpp   \
    BLVSource2.cpp          \
    BOSource2.cpp           \
    CCArabicSource2.cpp     \
    KJBOSource.cpp

!nosearch:SOURCES +=        \
    SqliteUnicodeSearch.cpp \
    SearchThread.cpp

# Please do not modify the following two lines. Required for deployment.
include(deployment.pri)
qtcAddDeployment()
