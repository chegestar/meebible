import QtQuick 1.1
import com.nokia.symbian 1.1

PageStackWindow {
    initialPage: Page {
        Button {
            anchors.centerIn: parent
            text: "This is QML UI"
            onClicked: Qt.quit()
        }
    }
}
