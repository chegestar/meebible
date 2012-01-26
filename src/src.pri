QT += core sql network xml xmlpatterns webkit gui declarative

# DEFINES += DEBUGPATHS

nosearch:DEFINES += NOSEARCH
free:DEFINES += FREEVERSION

DEFINES += INSTALLPREFIX=\\\"$$INSTALLDIR\\\"


TARGET = meebible
target.path = $$INSTALLDIR/bin
INSTALLS += target



CONFIG += qdeclarative-boostable
CONFIG += console
CONFIG += warn_on
CONFIG -= debug
CONFIG -= app_bundle


INCLUDEPATH += /usr/include/applauncherd
LIBS += -licui18n -lsqlite3 -lmdeclarativecache


HEADERS +=                      \
    src/Language.h              \
    src/Languages.h             \
    src/Translation.h           \
    src/ChapterRequest.h        \
    src/Source.h                \
    src/BibleView.h             \
    src/Cache.h                 \
    src/Paths.h                 \
    src/Place.h                 \
    src/EasyXml.h               \
    src/BibleWebPage.h          \
    src/Fetcher.h               \
    src/Utils.h                 \
    src/Settings.h              \
    src/MultiSource.h           \
    src/MultiTranslation.h      \
    src/Parser.h                \
    src/ParserFactory.h         \
    src/BibleOnlineParser.h     \
    src/BibeleLVParser.h        \
    src/CCArabicParser.h        \
    src/KJBOParser.h            \
    src/NWTParser.h

SOURCES +=                      \
    src/main.cpp                \
    src/Language.cpp            \
    src/Languages.cpp           \
    src/Translation.cpp         \
    src/ChapterRequest.cpp      \
    src/Source.cpp              \
    src/BibleView.cpp           \
    src/Cache.cpp               \
    src/Paths.cpp               \
    src/Place.cpp               \
    src/EasyXml.cpp             \
    src/BibleWebPage.cpp        \
    src/Fetcher.cpp             \
    src/Settings.cpp            \
    src/MultiSource.cpp         \
    src/MultiTranslation.cpp    \
    src/Parser.cpp              \
    src/ParserFactory.cpp       \
    src/BibleOnlineParser.cpp   \
    src/BibeleLVParser.cpp      \
    src/CCArabicParser.cpp      \
    src/KJBOParser.cpp          \
    src/NWTParser.cpp


!nosearch:HEADERS +=            \
    src/SqliteUnicodeSearch.h   \
    src/SearchThread.h
!nosearch:SOURCES +=            \
    src/SqliteUnicodeSearch.cpp \
    src/SearchThread.cpp
