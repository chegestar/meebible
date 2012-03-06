import Qt 4.7

import com.nokia.meego 1.0

Sheet {
    id: sheet


    property alias headerText: header.text
    property alias rejectButtonText: rejectButton.text


    function openSheet() { open() }
    function closeSheet() { close() }


    buttons: [
        Label {
            id: header

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 20

            font.pixelSize: 32
            font.family: "Nokia Pure Text Light"
            font.bold: false
        },

        SheetButton {
            id: rejectButton

            text: qsTr("Close")

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 20

            onClicked: sheet.reject()
        }
    ]
}