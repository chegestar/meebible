import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import MeeBible 0.1

Sheet {
    id: dialog


    property QtObject translation: settings.translation

    property alias query: field.text

    signal placeSelected(string bookCode, int chapterNo)


    function startSearch() {
        if (field.text == "")
            return

        cache.search(translation, field.text)
    }


    onVisibleChanged: {
        if (visible && field.text == "")
            field.forceActiveFocus()
    }


    buttons: [
        SheetButton {
            id: close
            text: qsTr("Close")

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10

            onClicked: dialog.reject()
        },

        TextField {
            id: field

            placeholderText: qsTr("Search...")

            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: close.left


            platformSipAttributes: SipAttributes {
                actionKeyIcon: "/usr/share/themes/blanco/meegotouch/icons/icon-m-toolbar-search-selected.png"
                actionKeyEnabled: true
            }

            Keys.onReturnPressed: {
                platformCloseSoftwareInputPanel()
                dialog.startSearch()
            }


            Image {
                id: image

                // source: field.text.length > 0 ? "image://theme/icon-m-input-clear" : "image://theme/icon-m-common-search"
                source: "image://theme/icon-m-common-search"

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10

                width: height


//              It seems like MouseArea doesn't work in TextField in 39-5 firmware :(
//                MouseArea {
//                    anchors.fill: parent
//
//                    onClicked: field.visible = false // dialog.startSearch()
//                }
            }

            BusyIndicator {
                id: busyIndicator

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 15

                running: visible

                platformStyle: BusyIndicatorStyle {
                    size: "medium"
                    inverted: false
                }
            }

            state: cache.searchInProgress ? "busy" : "idle"

            states: [
                State {
                    name: "idle"

                    PropertyChanges {
                        target: image
                        visible: true
                    }

                    PropertyChanges {
                        target: busyIndicator
                        visible: false
                    }
                },
                State {
                    name: "busy"

                    PropertyChanges {
                        target: image
                        visible: false
                    }

                    PropertyChanges {
                        target: busyIndicator
                        visible: true
                    }
                }
            ]
        }
    ]

    content: Item {
        id: item


        Connections {
            target: cache

            onSearchStarted: {
                item.state = "list"

                results.clear()
            }
            onSearchFinished: {
                if (results.count == 0)
                    item.state = "nothing"
            }

            onMatchFound: {
                results.append({
                    title: translation.bookName(bookCode) + ' ' + chapterNo,
                    subtitle: match,
                    bookCode: bookCode,
                    chapterNo: chapterNo,
                    matchCount: matchCount
                })
            }
        }


        anchors.fill: parent



        ListView {
            id: list

            anchors.fill: parent

            clip: true

            cacheBuffer: 70

            model: ListModel {
                id: results
            }

            delegate: ListDelegate {
                onClicked: dialog.placeSelected(bookCode, chapterNo)

                clip: true

                x: 10
                width: parent.width - 20

                // com.nokia.extras.CountBubble doesn't works well with inverted theme
                Item {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: 15

                    width: 25
                    height: 25

                    BorderImage {
                        source: "image://theme/meegotouch-countbubble-background"
                        anchors.fill: parent
                        border { left: 10; top: 10; right: 10; bottom: 10 }
                    }

                    Text {
                        text: matchCount
                        color: theme.inverted ? '#fff' : '#000'
                        font.pixelSize: 15
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
        ScrollDecorator { flickableItem: list; __rightPageMargin: 30 }

        Item {
            id: nothing

            anchors.fill: parent

            Label {
                anchors.centerIn: parent

                text: qsTr("Nothing found")
                color: theme.inverted ? '#444' : '#888'
                font.pixelSize: 60
                font.family: "Nokia Pure Text Light"
            }
        }


        state: "list"

        states: [
            State {
                name: "list"

                PropertyChanges {
                    target: list
                    visible: true
                }
                PropertyChanges {
                    target: nothing
                    visible: false
                }
            },
            State {
                name: "nothing"

                PropertyChanges {
                    target: list
                    visible: false
                }
                PropertyChanges {
                    target: nothing
                    visible: true
                }
            }
        ]
    }
}