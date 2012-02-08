import QtQuick 1.1
import com.meego 1.0

Page {
    id: page


    function sendForm() {
        feedback.send(nameField.text, emailField.text, messageField.text)
        busyDialog.open()
    }


    Header {
        id: header
        text: qsTr("Feedback")
    }


    Flickable {
        id: flickable

        flickableDirection: Flickable.VerticalFlick

        clip: true

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: parent.bottom

        contentWidth: form.width
        contentHeight: form.height + 40

        Column {
            id: form

            x: 20
            y: 20
            width: page.width - 40

            spacing: 20

            TextField {
                id: nameField

                width: parent.width

                placeholderText: qsTr("Your name")
            }

            TextField {
                id: emailField

                width: parent.width

                placeholderText: qsTr("Your E-Mail")

                inputMethodHints: Qt.ImhEmailCharactersOnly
            }

            TextArea {
                id: messageField

                width: parent.width

                height: 400

                placeholderText: qsTr("Comments\nSuggestions\nImprovements\nCritics\nNew translations\n...")
            }

            Button {
                id: sendButton

                width: parent.width

                text: qsTr("Send")

                onClicked: {
                    if (emailField.text.trim() != '')
                        page.sendForm()
                    else
                        noEmailConfirmation.open()
                }
            }

        }
    }
    ScrollDecorator { flickableItem: flickable }


    Dialog {
        id: busyDialog

        content: Column {
            anchors.left: parent.left
            anchors.right: parent.right

            spacing: 20

            BusyIndicator {
                anchors.horizontalCenter: parent.horizontalCenter

                running: busyDialog.status != DialogStatus.Closed

                platformStyle: BusyIndicatorStyle {
                    size: "large"
                    inverted: true
                }
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter

                text: qsTr("Sending feedback")

                font.pixelSize: 36

                platformStyle: LabelStyle {
                    inverted: true
                }
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter

                text: qsTr("Cancel")

                __dialogButton: true

                platformStyle: ButtonStyle {
                    inverted: true
                }

                onClicked: feedback.abort()
            }
        }
    }


    QueryDialog {
        id: thanksDialog

        titleText: qsTr("Feedback sent")

        message: qsTr("Thank you! Your feedback is highly appreciated. We will answer you as soon as possible.")

        acceptButtonText: qsTr("OK")
    }

    QueryDialog {
        id: failDialog

        titleText: qsTr("Sending failed")

        message: qsTr("Your feedback was not sent. Please check internet connection and try again.")

        acceptButtonText: qsTr("OK")
    }

    QueryDialog {
        id: noEmailConfirmation

        titleText: qsTr("No E-Mail?")

        message: qsTr("You have not specified E-Mail address. We will not be able to answer you!")

        acceptButtonText: qsTr("Send anyway")
        rejectButtonText: qsTr("Return to form")

        onAccepted: page.sendForm()
    }


    Connections {
        target: feedback

        onSuccess: {
            console.log('success')
            busyDialog.close()
            pageStack.pop()
            thanksDialog.open()
        }
        onFail: {
            console.log('fail')
            busyDialog.close()
            if (! aborted)
                failDialog.open()
        }
    }


    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back"
            onClicked: pageStack.pop()
        }
    }
}
