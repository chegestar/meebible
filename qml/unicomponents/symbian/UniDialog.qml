import Qt 4.7
import com.nokia.symbian 1.1

Dialog {
    id: dialog

    property alias titleText: titleLabel.text

    title: [
        Label {
            id: titleLabel
            anchors.centerIn: parent
        }
    ]

    buttons: [
        Button {
            text: "Close"
            onClicked: dialog.reject()
        }
    ]
}
