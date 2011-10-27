import QtQuick 1.1

// This is for CommonDialog
import "/usr/lib/qt4/imports/com/nokia/meego/" 1.0


CommonDialog {
    id: dialog

    titleText: qsTr("Select Book")

    property alias bookModel: bookList.model




    function open(bookCode, chapterNo) {
        contentItem.state = "bookSelection"
        if (status == DialogStatus.Closed)
            status = DialogStatus.Opening

        bookList.currentIndex = bookModel.bookCodes().indexOf(bookCode)
        bookList.positionViewAtIndex(bookList.currentIndex, ListView.Center)

        chaptersList.currentIndex = chapterNo-1
        chaptersList.positionViewAtIndex(chaptersList.currentIndex, ListView.Contain)
    }


    function bookCode() {
        if (bookList.currentIndex == -1)
            return "xxx"

        return bookModel.bookCodeAt(bookList.currentIndex)
    }

    function bookName() {
        return bookModel.bookName(bookCode())
    }

    function chapterNo() {
        return chaptersList.currentIndex + 1
    }

    function verseNo() {
        return versesList.currentIndex + 1
    }

    content: Item {
        id: contentItem
        width: parent.width

        anchors.horizontalCenter: parent.horizontalCenter

        height: dialog.parent.height * 0.8

        clip: true

        ListView {
            id: bookList

            anchors.top: parent.top
            anchors.bottom: parent.bottom

            width: parent.width

            clip: true

            model: settings.translation

            cacheBuffer: 70

            delegate: SimpleListDelegate {
                selectable: true

                onClicked: {
                    contentItem.state = "chapterSelection"
                }
            }


            onCurrentIndexChanged: {
                var bookCode = bookList.model.bookCodeAt(currentIndex)

                chaptersModel.clear()
                var chaptersCount = bookList.model.chaptersInBook(bookCode)
                for (var i = 1; i <= chaptersCount; i++)
                    chaptersModel.append({ value: i })
            }
        }
        ScrollDecorator { flickableItem: bookList }


        Item {
            id: secondPage

            anchors.left: bookList.right
            width: parent.width
            height: parent.height


            anchors.bottom: parent.bottom



            Item {
                id: chapterLabel

                height: 30

                anchors.left: parent.left
                anchors.right: parent.horizontalCenter

                Label {
                    id: _chapterLabel

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Chapter:")
                    color: "white"
                }
            }
            Item {
                id: verseLabel

                height: chapterLabel.height

                anchors.left: parent.horizontalCenter
                anchors.right: parent.right

                Label {
                    id: _verseLabel

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Verse:")
                    color: "white"
                }
            }


            ListView {
                id: chaptersList

                anchors.left: parent.left
                anchors.right: parent.horizontalCenter
                anchors.top: chapterLabel.bottom
                anchors.bottom: spacer.top

                model: ListModel {
                    id: chaptersModel
                }

                clip: true
                cacheBuffer: 70

                delegate: SimpleListDelegate {
                    centered: true
                    selectable: true
                }

                onCurrentIndexChanged: {
                    versesModel.clear()
                    if (currentIndex == -1)
                        return

                    var versesCount = bookList.model.versesInChapter(
                        bookList.model.bookCodeAt(bookList.currentIndex),
                        currentIndex + 1
                    )
                    for (var i = 1; i <= versesCount; i++)
                        versesModel.append({ value: i })
                }
            }
            ScrollDecorator { flickableItem: chaptersList }

            ListView {
                id: versesList

                anchors.left: parent.horizontalCenter
                anchors.right: parent.right
                anchors.top: verseLabel.bottom
                anchors.bottom: spacer.top

                model: ListModel {
                    id: versesModel
                }

                clip: true
                cacheBuffer: 70

                delegate: SimpleListDelegate {
                    centered: true
                    selectable: true
                }
            }
            ScrollDecorator { flickableItem: versesList }


            Rectangle {
                id: spacer

                height: 10

                visible: false

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: backButton.top
            }


            Button {
                id: backButton

                __dialogButton: true

                anchors.left: parent.left
                width: parent.width / 4
                anchors.bottom: parent.bottom

                platformStyle: ButtonStyle {
                    inverted: true
                }

                text: "←"

                onClicked: contentItem.state = "bookSelection"
            }

            Button {
                id: acceptButton

                __dialogButton: true

                anchors.left: backButton.right
                anchors.leftMargin: 20
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                platformStyle: ButtonStyle {
                    inverted: true
                }

                text: qsTr("OK")

                onClicked: dialog.accept()
            }
        }


        state: "bookSelection"

        states: [
            State {
                name: "bookSelection"

                AnchorChanges {
                    target: bookList
                    anchors.left: contentItem.left
                }
            },
            State {
                name: "chapterSelection"

                AnchorChanges {
                    target: bookList
                    anchors.right: contentItem.left
                }
            }
        ]

        transitions: Transition {
            AnchorAnimation { duration: 200 }
        }
    }

    buttons: Item { }
}