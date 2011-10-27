#include "BibleView.h"

#include <QDebug>
#include <QFile>

#include <QWebFrame>
#include <QNetworkAccessManager>

#include <QElapsedTimer>

#include <QDesktopServices>

#include "ChapterRequest.h"
#include "Language.h"
#include "Translation.h"
#include "Cache.h"
#include "BibleWebPage.h"
#include "Paths.h"

#include "SqliteUnicodeSearch.h"


BibleView::BibleView(QGraphicsItem *parent):
    QGraphicsWebView(parent), _translation(0), _chapterNo(0), _fontSize(30)
{
    QElapsedTimer timer;
    timer.start();


    BibleWebPage* page = new BibleWebPage(this);
    page->setLinkDelegationPolicy(QWebPage::DelegateExternalLinks);
    connect(page, SIGNAL(linkClicked(const QUrl&)), this, SLOT(onLinkClicked(const QUrl&)));
    setPage(page);


    QFile css(Paths::style_css());
    css.open(QIODevice::ReadOnly);
    QByteArray cssContent = css.readAll();

    settings()->setUserStyleSheetUrl(QUrl(
        QString("data:text/css;charset=utf-8;base64,%1").arg(
            QString::fromAscii(cssContent.toBase64())
        )
    ));

    QFile script(Paths::script_js());
    script.open(QIODevice::ReadOnly);
    _js = QString::fromUtf8(script.readAll());


    _nam = new QNetworkAccessManager(this);


    connect(page->mainFrame(), SIGNAL(javaScriptWindowObjectCleared()), this, SLOT(onJavaScriptWindowObjectCleared()));
    connect(this, SIGNAL(loadFinished(bool)), this, SLOT(onLoadFinished(bool)));


    _searchMode = false;
    _searchNeedle = "";
    _matchCount = 0;
    _matchIndex = 0;
}


BibleView::~BibleView()
{
}


Translation* BibleView::translation() const
{
    return _translation;
}

void BibleView::setTranslation(Translation *translation)
{
    if (_translation == translation) return;

    QString origBookName;

    if (_translation)
        origBookName = _translation->bookName(_bookCode);

    _translation = translation;

    loadChapter();

    translationChanged();
    titleChanged();
}


void BibleView::setAndLoad(const QString& bookCode, int chapterNo, int verseNo)
{
    setBookCode(bookCode);
    setChapterNo(chapterNo);

    _verseNo = verseNo;

    loadChapter();
}

void BibleView::loadChapter()
{
    if (_translation == 0 || _bookCode.length() == 0)
    {
        return;
    }

    if (! Place(_bookCode, _chapterNo).isValid(_translation))
    {
//        clearDisplay(origBookName.isEmpty() ? "" : QString("This translation doesn't contain %1").arg(origBookName));
        clearDisplay("Current translation doesn't contain this book");
        qDebug() << "Absent" << _translation << _bookCode << _chapterNo;
        return;
    }

    QString fromCache = Cache::instance()->loadChapter(_translation, _bookCode, _chapterNo);

    if (! fromCache.isEmpty())
    {
        displayHtml(fromCache);
        scrollToVerse(_verseNo);
        chapterLoaded();
    }
    else
    {
        ChapterRequest* request = _translation->requestChapter(_nam, _bookCode, _chapterNo);

        if (request)
            connect(request, SIGNAL(finished(QString)), this, SLOT(onChapterRequestFinished(QString)));

        loading();
    }
}


void BibleView::onChapterRequestFinished(QString html)
{
    ChapterRequest* request = dynamic_cast<ChapterRequest*>(sender());

    if (request->error() != QNetworkReply::NoError)
    {
        clearDisplay("<h3>Cannot load chapter</h3> Please check your internet connection");
        chapterLoadingError();
    }
    else
    {
        if (request->bookCode() == _bookCode && request->chapterNo() == _chapterNo)
        {
            displayHtml(html);
            scrollToVerse(_verseNo);
            chapterLoaded();
        }

        Cache::instance()->saveChapter(
            request->translation(),
            request->bookCode(),
            request->chapterNo(),
            html
        );
    }

    request->deleteLater();
}


void BibleView::displayHtml(QString html)
{
    _html = html;
    setHtml(_html);

    stopSearchMode();
}

void BibleView::scrollToVerse(int verseNo)
{
    if (verseNo > 1)
    {
        page()->mainFrame()->evaluateJavaScript(QString("selectVerse(%1)").arg(verseNo)).toInt();
        needToScroll(page()->mainFrame()->evaluateJavaScript(QString("verseOffset(%1)").arg(verseNo)).toInt());
    }
    else
        needToScroll(0);
}

void BibleView::clearDisplay(const QString& error)
{
    setHtml("<h2>" + error + "</h2>");
}


bool BibleView::validLocation() const
{
    if (_translation == 0) return false;
    return Place(_bookCode, _chapterNo).isValid(_translation);
}


void BibleView::loadPrevChapter()
{
    if (! validLocation()) return;

    Place next = Place(_bookCode, _chapterNo).prevChapter(_translation);

    setAndLoad(next.bookCode(), next.chapterNo(), 1);
}

void BibleView::loadNextChapter()
{
    if (! validLocation()) return;

    Place prev = Place(_bookCode, _chapterNo).nextChapter(_translation);

    setAndLoad(prev.bookCode(), prev.chapterNo(), 1);
}



void BibleView::onJavaScriptWindowObjectCleared()
{
    //
}

void BibleView::onLoadFinished(bool ok)
{
    Q_UNUSED(ok)

    page()->mainFrame()->evaluateJavaScript(_js);
    applyFontSize();
    applyLineSpacing();
    applyInverted();
}


Place BibleView::selectedPlace()
{
    if (! validLocation()) return Place();

    QStringList jsList = page()->mainFrame()->evaluateJavaScript("selectedVersesList()").toString().split(",", QString::SkipEmptyParts);

    QSet<int> verses;
    for (int i = 0; i < jsList.size(); i++)
        verses += jsList[i].toInt();

    return Place(_bookCode, _chapterNo, verses);
}



int BibleView::preferredWidth()
{
    return page()->preferredContentsSize().width();
}

void BibleView::setPreferredWidth(int width)
{
    page()->setPreferredContentsSize(QSize(width, 100));
}




/////////////////////////////////////////

void BibleView::startSearchMode(const QString& needle)
{
    _searchNeedle = needle;
    searchNeedleChanged();

    displayHtml(SqliteUnicodeSearch::highlightMatches(_html, needle, &_matchCount));
    matchCountChanged();

    if (_searchMode == false)
    {
        _searchMode = true;
        searchModeChanged();
    }

    setMatchIndex(0);
}


void BibleView::stopSearchMode()
{
    if (_searchMode == true)
    {
        _searchMode = false;
        searchModeChanged();
    }
}

void BibleView::setMatchIndex(int index)
{
    ensureVisible(page()->mainFrame()->evaluateJavaScript(QString("highlightMatch(%1)").arg(
        index - _matchCount
    )).toInt());

    _matchIndex = index;
    matchIndexChanged();
}

/////////////////////////////////////////



void BibleView::onLinkClicked(const QUrl& url)
{
    if (url.scheme() == "mailto" || url.scheme() == "http")
        QDesktopServices::openUrl(url);
}




QString BibleView::title() const
{
    Place place(_bookCode, _chapterNo);
    if (_translation == 0 || ! place.isValid(_translation))
        return "Unknown";

    return place.toString(_translation);
}



void BibleView::setFontSize(int value)
{
    _fontSize = value;
    applyFontSize();
    fontSizeChanged();
}

void BibleView::applyFontSize()
{
    page()->mainFrame()->evaluateJavaScript(QString("setFontSize(%1)").arg(_fontSize));
}

void BibleView::setLineSpacing(float value)
{
    _lineSpacing = value;
    applyLineSpacing();
    lineSpacingChanged();
}

void BibleView::applyLineSpacing()
{
    page()->mainFrame()->evaluateJavaScript(QString("setLineSpacing(%1)").arg(_lineSpacing));
}



void BibleView::setInverted(bool inverted)
{
    _inverted = inverted;
    applyInverted();
}

void BibleView::applyInverted()
{
    page()->mainFrame()->evaluateJavaScript(QString("setInverted(%1)").arg(_inverted));
}