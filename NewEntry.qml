import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    id: root
    spacing: 0

    Layout.fillHeight: true

    ToolBar {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignTop
        Layout.preferredHeight: 50

        background: null

        Item {
            anchors.fill: parent

            RoundButton {
                text: "<"
                font.pixelSize: 18
                font.bold: true
                flat: true

                width: height

                onClicked: Navigation.pop()

                Layout.alignment: Qt.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            Label {
                text: "Добавить запись"
                font.pixelSize: 18
                font.bold: true

                anchors.fill: parent

                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignHCenter
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.preferredWidth: parent.width

        RoundButton {
            Layout.alignment: Qt.AlignHCenter

            text: "Сохранить"
            font.pixelSize: 18

            radius: 8

            implicitWidth: 100
            implicitHeight: 50

            onClicked: Navigation.pop()
        }
    }
}
