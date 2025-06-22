import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

ApplicationWindow {
    width: 640
    height: 480
    minimumWidth: 400
    minimumHeight: 300

    visible: true
    title: qsTr("Mood tracker")

    Material.theme: Material.Dark

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: HomePage{}

        Component.onCompleted: Navigation.stackView = stackView
    }

    Item {
        id: backHandler
        visible: false

        Keys.onBackPressed: {
            if(stackView.depth > 1)
                stackView.pop();
            else
                Qt.quit();
        }

        Component.onCompleted: forceActiveFocus()
    }
}
