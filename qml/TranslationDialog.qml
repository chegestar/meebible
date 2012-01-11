import QtQuick 1.1
import com.nokia.symbian 1.1

ModelSelectionDialog {
    titleText: qsTr("Select Translation")

    // listHeight: 150

    model: settings.language

    function translation() {
        return model.translationAt(selectedIndex)
    }
}
