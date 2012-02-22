import QtQuick 1.1

import com.meego 1.0


Sheet {
    signal bookmarkSelected(variant place)


    id: dialog

    buttons: [
        Label {
            id: header

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10

            text: qsTr("Bookmarks")

            font.pixelSize: 32
            font.family: "Nokia Pure Text Light"
            font.bold: false
        },

        SheetButton {
            text: qsTr("Close")

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10

            onClicked: dialog.reject()
        }
    ]


    content: Item {
        id: item

        anchors.fill: parent


        ListView {
            id: list

            anchors.fill: parent

            clip: true

            cacheBuffer: 50

            model: bookmarks

            delegate: BookmarkItem {
                x: 10
                width: parent.width - 20

                onClicked: {
                    dialog.bookmarkSelected(model.place)
                    dialog.accept()
                }

                onPressAndHold: {
                    dialog._pressAndHoldIndex = index
                    itemMenu.open()
                }
            }
        }
        ScrollDecorator { flickableItem: list }
    }


    property int _pressAndHoldIndex: -1

    Menu {
        id: itemMenu

        MenuLayout {
            MenuItem {
                text: qsTr("Delete")

                onClicked: {
                    console.log(dialog._pressAndHoldIndex)
                    bookmarks.deleteBookmark(dialog._pressAndHoldIndex)
                }
            }
        }
    }
}
