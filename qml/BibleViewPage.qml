import QtQuick 1.1
import com.meego 1.0
import MeeBible 0.1

Page {
    id: page


    function setTranslation(translation) { bibleView.setTranslation(translation) }
    function loadChapter() { bibleView.loadChapter() }
    function setAndLoad(bookCode, chapterNo, verseNo, highlight) { bibleView.setAndLoad(bookCode, chapterNo, verseNo, highlight) }
    function loadPrevChapter() { bibleView.loadPrevChapter() }
    function loadNextChapter() { bibleView.loadNextChapter() }


    property bool created: false

    Binding {
        target: settings
        property: "bookCode"
        value: bibleView.bookCode
        when: created
    }
    Binding {
        target: settings
        property: "chapterNo"
        value: bibleView.chapterNo
        when: created
    }
    Component.onCompleted: {
        bibleView.bookCode = settings.bookCode
        bibleView.chapterNo = settings.chapterNo
        created = true
    }


    Rectangle {
        anchors.fill: parent

        clip: true

        Flickable {
            id: flickable

            anchors.fill: parent

            contentWidth: bibleView.width
            contentHeight:  bibleView.height

            BibleView {
                id: bibleView

                width: page.width

                resizesToContents: true
                preferredWidth: page.width

                url: "about:blank"

                translation: settings.translation



                Component.onCompleted: loadChapter()

                onChapterLoaded: { flickable.contentY = 0; page.state = "normal" }
                onChapterLoadingError: { flickable.contentY = 0; page.state = "normal" }
                onLoading: page.state = "loading"

                onNeedToScroll: {
                    var maxY = flickable.contentHeight - flickable.height
                    if (y < maxY)
                        flickable.contentY = y
                    else
                        if (maxY < 0)
                            flickable.contentY = 0
                        else
                            flickable.contentY = maxY
                }
            }
        }
        ScrollDecorator { flickableItem: flickable }
    }


    Rectangle {
        id: busyIndicator

        anchors.fill: parent

        color: '#fff'

        BusyIndicator {
            anchors.centerIn: parent

            running: true

            platformStyle: BusyIndicatorStyle {
                size: "large"
            }
        }

        state: "invisible"

        states: [
            State {
                name: "invisible"

                PropertyChanges {
                    target: busyIndicator
                    opacity: 0.0
                }
            },
            State {
                name: "visible"

                PropertyChanges {
                    target: busyIndicator
                    opacity: 0.7
                }
            }
        ]

        transitions: Transition {
            NumberAnimation {
                properties: "opacity"
                duration: 100
            }
        }
    }

    state: "normal"

    states: [
        State {
            name: "normal"

            PropertyChanges {
                target: busyIndicator
                state: "invisible"
            }
        },
        State {
            name: "loading"

            PropertyChanges {
                target: busyIndicator
                state: "visible"
            }
        }
    ]
}
