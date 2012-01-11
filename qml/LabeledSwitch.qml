import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    property alias text: _label.text
    property alias checked: _switch.checked


    width: parent.width
    height: _switch.height

    Label {
        id: _label
        font.bold: true

        anchors.verticalCenter: parent.verticalCenter
    }

    Switch {
        id: _switch

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
}
