import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
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

                width: 60
                height: 60

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

    ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 20

        spacing: 20

        TextArea {
            id: descriptionField

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 100

            placeholderText: "Как прошел ваш день?"
        }

        Button {
            Layout.alignment: Qt.AlignHCenter

            text: "Сохранить"
            font.pixelSize: 18

            //radius: 8

            onClicked: Navigation.pop()
        }
    }
}
