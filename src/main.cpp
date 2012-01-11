#include <QApplication>
#include <QDebug>
#include <QtDeclarative>
#include <QtGlobal>

#ifndef SYMBIAN
    #include <MDeclarativeCache>
#endif

#include <QElapsedTimer>

#include <QTranslator>
#include <QLocale>

#include "Paths.h"
#include "Cache.h"
#include "Languages.h"
#include "Language.h"
#include "NWTSource.h"
#include "BOSource2.h"
#include "BLVSource2.h"
#include "CCArabicSource2.h"
#include "KJBOSource.h"
#include "Translation.h"
#include "BibleView.h"
#include "Fetcher.h"
#include "Settings.h"


#include <cstdio>
void myMessageOutput(QtMsgType type, const char *msg)
{
    FILE *f = fopen("c:\\meebible.log", "a");
    switch (type)
    {
        case QtDebugMsg:    fprintf(f, "debug> %s\n", msg); break;
        case QtWarningMsg:  fprintf(f, "warn > %s\n", msg); break;
        case QtCriticalMsg: fprintf(f, "crit > %s\n", msg); break;
        case QtFatalMsg:    fprintf(f, "fatal> %s\n", msg); abort(); break;
    }
    fclose(f);
}


Q_DECL_EXPORT int main(int argc, char *argv[])
{
    qInstallMsgHandler(myMessageOutput);

    QElapsedTimer timer;
    timer.start();

    #ifndef SYMBIAN
        QApplication *app = MDeclarativeCache::qApplication(argc, argv);
    #else
        QApplication *app = new QApplication(argc, argv);
    #endif
    app->setOrganizationName("MeeBible");
    app->setApplicationName("MeeBible");

    Paths::init();

    QTranslator translator;
//    translator.load(Paths::translationFile("ru"));
    translator.load(Paths::translationFile(QLocale::system().name()));
    app->installTranslator(&translator);

    Cache cache;

    Languages languages;


    NWTSource nwtSource;
    nwtSource.addTranslationsToList(&languages);
    BOSource2 boSource2;
    boSource2.addTranslationsToList(&languages);
    BLVSource2 blvSource2;
    blvSource2.addTranslationsToList(&languages);
    CCArabicSource2 ccarabicSource2;
    ccarabicSource2.addTranslationsToList(&languages);
    KJBOSource kjbosource;
    kjbosource.addTranslationsToList(&languages);

    Settings settings(&languages);

    QDeclarativeEngine engine;


    qmlRegisterType<Language>();
    qmlRegisterUncreatableType<Translation>("MeeBible", 0, 1, "Translation", "Translation is abstract");
    qmlRegisterType<BibleView>("MeeBible", 0, 1, "BibleView");
    qmlRegisterType<Fetcher>("MeeBible", 0, 1, "Fetcher");


    #ifndef SYMBIAN
        QDeclarativeView* view = MDeclarativeCache::qDeclarativeView();
    #else
        QDeclarativeView* view = new QDeclarativeView();
    #endif
    view->setAttribute(Qt::WA_NoSystemBackground);


    view->rootContext()->setContextProperty("languages", &languages);
    view->rootContext()->setContextProperty("cache", &cache);
    view->rootContext()->setContextProperty("settings", &settings);

    #ifdef FREEVERSION
        view->rootContext()->setContextProperty("freeversion", true);
    #else
        view->rootContext()->setContextProperty("freeversion", false);
    #endif


    #ifdef NOSEARCH
        qDebug() << "Search disabled";
        view->rootContext()->setContextProperty("NOSEARCH", true);
    #else
        view->rootContext()->setContextProperty("NOSEARCH", false);
    #endif


    view->setSource(QUrl::fromLocalFile(Paths::qmlMain()));


    view->showFullScreen();



    return app->exec();
}
