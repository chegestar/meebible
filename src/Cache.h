#ifndef CACHE_H
#define CACHE_H

#include <QObject>
#include <QRegExp>
#include <QVariant>
#include <QSet>
#include <QPair>

#include "Place.h"
#include "Indexer.h"


class QThread;


class sqlite3;
class sqlite3_stmt;

class Translation;


class Cache: public QObject
{
    Q_OBJECT

public:
    static Cache* instance();

    Cache();
    virtual ~Cache();

    void saveChapter(const Translation* translation, const Place& place, QString html);

    QString loadChapter(const Translation* translation, const Place& place);

    bool hasChapter(const Translation* translation, const Place& place);

    int totalChaptersInCache(const Translation* translation);


    QSet<QPair<QString, int> > availableChapters(const Translation* translation);


    void beginTransaction();
    void commitTransaction();


    void saveXML(const QString& name, const QString& content);
    bool hasXML(const QString& name);
    QString loadXML(const QString& name);


public slots:
    void clearCache();


    QList<QVariant> searchTest(Translation* translation, const QString& query);


private:
    static Cache* _instance;

    sqlite3* _db;

    sqlite3_stmt* _stmt_saveChapter;
    sqlite3_stmt* _stmt_loadChapter;
    sqlite3_stmt* _stmt_hasChapter;
    sqlite3_stmt* _stmt_totalChapters;
    sqlite3_stmt* _stmt_availableChapters;

    #ifdef ASYNC_DB_IO
        QThread* _asyncThread;
    #endif

    QRegExp _stripTags;
    QRegExp _stripSpaces;
    QRegExp _stripStyles;

    Indexer _indexer;


    void execWithCheck(const char* sql);

    void openDB();
    void closeDB();
};

#endif // CACHE_H
