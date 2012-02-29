import QtQuick 1.1
import com.meego 1.0

Item {
    id: item

    property alias titleText: title.text
    property alias valueText: value.text

    signal clicked()

    anchors.left: parent.left
    anchors.right: parent.right

    height: 90

    Rectangle {
        anchors.fill: parent
        color: theme.inverted ? '#444' : '#ccc'
        visible: mouseArea.pressed
    }

    Label {
        id: title

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 10

        font.pixelSize: 26
        font.bold: true
        color: mouseArea.pressed ? "#797979" : (theme.inverted ? "#ffffff" : "#282828")
    }

    Label {
        id: value

        anchors.left: parent.left
        anchors.leftMargin: 10

        anchors.top: title.bottom

        font.family: "Nokia Pure Text Light"
        color: mouseArea.pressed ? "#797979" : (theme.inverted ? "#c8c8c8" : "#505050")
    }

    Image {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 10

        source: theme.inverted ? 'image://theme/meegotouch-combobox-indicator-inverted' : 'image://theme/meegotouch-combobox-indicator'
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        onClicked: item.clicked()
    }
}
