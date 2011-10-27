import QtQuick 1.1

// This is for CommonDialog
import "/usr/lib/qt4/imports/com/nokia/meego/" 1.0

import com.nokia.extras 1.1

import MeeBible 0.1


CommonDialog {
    id: dialog

    titleText: qsTr("Downloading Bible")

    property Fetcher fetcher: Fetcher {
        translation: settings.translation
    }

    Connections {
        target: fetcher

        onUpdate: {
            label.text = text
            bookProgress.value = bookPercent
            overallProgress.value = overallPercent
        }

        onFinished: dialog.accept()
    }

    function start() {
        label.text = qsTr("Connecting...")
        if (fetcher.start() == false)
        {
            nothingToDo.open()
            return false
        }
        else
            open()
    }

    onRejected: fetcher.stop()


    QueryDialog {
        id: nothingToDo

        titleText: qsTr("Nothing to do")
        message: qsTr("You already have downloaded whole Bible in selected language and translation")

        acceptButtonText: qsTr("OK")
    }


    content: Column {
        id: contentItem

        width: parent.width
        spacing: 20

        Item {
            width: dialog.width

            height: 40

            Label {
                id: label

                anchors.bottom: parent.bottom

                color: "white"
            }
        }

        ProgressBar {
            id: bookProgress
            width: dialog.width

            minimumValue: 0.0
            maximumValue: 1.0
        }

        ProgressBar {
            id: overallProgress
            width: dialog.width

            minimumValue: 0.0
            maximumValue: 1.0
        }

        Button {
            platformStyle: NegativeButtonStyle { }

            text: qsTr("Cancel")

            anchors.right: parent.right

            onClicked: dialog.reject()
        }
    }
}