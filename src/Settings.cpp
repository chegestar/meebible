#include "Settings.h"

#include <QDebug>

#include "Language.h"
#include "Languages.h"
#include "Translation.h"


Settings* Settings::_instance = 0;


Settings::Settings(Languages* langs, QObject* parent):
    QObject(parent), _languages(langs)
{
    if (_instance)
        qFatal("Second copy of Settings singleton");
    _instance = this;

    _langCode       = _settings.value("General/langCode", "e").toString();
    _transCode      = _settings.value("General/transCode", "kjv").toString();

    _bookCode       = _settings.value("General/bookCode", "ge").toString();
    if (_bookCode.isEmpty()) _bookCode = "ge";
    _chapterNo      = _settings.value("General/chapterNo", 1).toInt();
    _floatingHeader = _settings.value("General/floatingHeader", true).toBool();
    _fontSize       = _settings.value("General/fontSize", 30).toInt();
    _fontName       = _settings.value("General/fontName", "Nokia").toString();
    _lineSpacing    = _settings.value("General/lineSpacing", 1.3).toFloat();
    _scrollPos      = _settings.value("General/scrollPos", 0).toInt();
    _fullscreen     = _settings.value("General/fullscreen", false).toBool();
    _inverted       = _settings.value("General/inverted", false).toBool();

    _searchNoticeShown = _settings.value("Notices/searchNoticeShown", false).toBool();

    _webService     = _settings.value("Internals/webService", "meebible.org").toString();

    connect(_languages, SIGNAL(loadingFinished()), this, SLOT(onLanguagesLoadingFinished()));
}

Settings::~Settings()
{
    _settings.setValue("General/langCode", _langCode);
    _settings.setValue("General/transCode", _transCode);
    _settings.setValue("General/bookCode", _bookCode);
    _settings.setValue("General/chapterNo", _chapterNo);
    _settings.setValue("General/floatingHeader", _floatingHeader);
    _settings.setValue("General/fontSize", _fontSize);
    _settings.setValue("General/fontName", _fontName);
    _settings.setValue("General/lineSpacing", _lineSpacing);
    _settings.setValue("General/scrollPos", _scrollPos);
    _settings.setValue("General/fullscreen", _fullscreen);
    _settings.setValue("General/inverted", _inverted);

    _settings.setValue("Notices/searchNoticeShown", _searchNoticeShown);
}


void Settings::onLanguagesLoadingFinished()
{
    languageChanged();
    translationChanged();
}



Language* Settings::language() const
{
    return _languages->langByCode(_langCode);
}

void Settings::setLanguage(Language* lang)
{
    if (lang->code() == _langCode) return;

    _langCode = lang->code();

    if (language() && language()->translationByCode(_transCode) == 0)
    {
        Translation* trans = language()->translationAt(0);
        if (trans)
            _transCode = trans->code();
    }

    languageChanged();
    translationChanged();
}


Translation* Settings::translation() const
{
    Language *lang = language();
    if (lang)
        return lang->translationByCode(_transCode);
    else
        return 0;
}

void Settings::setTranslation(Translation* translation)
{
    if (translation->code() == _transCode) return;

    _transCode = translation->code();
    translationChanged();
}


QString Settings::bookCode() const
{
    return _bookCode;
}

void Settings::setBookCode(const QString& bookCode)
{
    if (_bookCode == bookCode) return;

    _bookCode = bookCode;
    bookCodeChanged();
}


int Settings::chapterNo() const
{
    return _chapterNo;
}

void Settings::setChapterNo(int chapterNo)
{
    if (_chapterNo == chapterNo) return;

    _chapterNo = chapterNo;
    chapterNoChanged();
}



bool Settings::floatingHeader() const
{
    return _floatingHeader;
}

void Settings::setFloatingHeader(bool show)
{
    if (_floatingHeader != show)
    {
        _floatingHeader = show;
        floatingHeaderChanged();
    }
}



int Settings::fontSize() const
{
    return _fontSize;
}

void Settings::setFontSize(int size)
{
    if (_fontSize != size)
    {
        _fontSize = size;
        fontSizeChanged();
    }
}


QString Settings::fontName() const
{
    return _fontName;
}

void Settings::setFontName(const QString& name)
{
    if (_fontName != name)
    {
        _fontName = name;
        fontNameChanged();
    }
}


float Settings::lineSpacing() const
{
    return _lineSpacing;
}

void Settings::setLineSpacing(float spacing)
{
    if (_lineSpacing != spacing)
    {
        _lineSpacing = spacing;
        lineSpacingChanged();
    }
}



int Settings::scrollPos() const
{
    return _scrollPos;
}

void Settings::setScrollPos(int pos)
{
    if (_scrollPos != pos)
    {
        _scrollPos = pos;
        scrollPosChanged();
    }
}



bool Settings::fullscreen() const
{
    return _fullscreen;
}

void Settings::setFullscreen(bool fs)
{
    if (_fullscreen != fs)
    {
        _fullscreen = fs;
        fullscreenChanged();
    }
}


bool Settings::searchNoticeShown() const { return _searchNoticeShown; }
void Settings::setSearchNoticeShown(bool shown) { _searchNoticeShown = shown; }


void Settings::setInverted(bool inverted)
{
    if (_inverted != inverted)
    {
        _inverted = inverted;
        invertedChanged();
    }
}
