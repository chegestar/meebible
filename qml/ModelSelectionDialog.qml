import QtQuick 1.1

import com.nokia.symbian 1.1

import "unicomponents"


UniDialog {
    id: dialog

    property alias listHeight: contentItem.height
    property alias model: listView.model

    property int selectedIndex: -1


    content: Item {
        id: contentItem
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter

        // height: listView.height < dialog.parent.height * 0.8 ? listView.height : dialog.parent.height * 0.8
        height: listView.contentHeight < 600 ? listView.contentHeight : 600

        ListView {
            id: listView

            anchors.fill: parent

            clip: true

            cacheBuffer: 70

            delegate: SimpleListDelegate {
                onClicked: {
                    selectedIndex = index
                    dialog.accept()
                }
            }
        }

        ScrollDecorator { flickableItem: listView }
    }
}
