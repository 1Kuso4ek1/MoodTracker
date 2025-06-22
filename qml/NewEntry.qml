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

        Label {
            text: "Как ваше настроение?"

            font.pixelSize: 24
            font.weight: 10

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter

            spacing: 15

            Repeater {
                id: repeater
                model: [ "😀", "😐", "😕", "😞", "😠" ]
                property var selectedIndex: 2

                RoundButton {
                    id: emojiButton
                    implicitWidth: 80
                    implicitHeight: 80
                    flat: true

                    required property string modelData
                    required property int index

                    text: modelData
                    font.family: "Noto Color Emoji [GOOG]"
                    font.pixelSize: 50

                    onClicked: repeater.selectedIndex = index

                    background: Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignCenter

                        radius: parent.radius

                        property bool selected: repeater.selectedIndex === parent.index

                        color: selected
                            ? Material.accent
                            : (parent.hovered ? Material.accent : "transparent")

                        opacity: parent.hovered && !selected ? 0.5 : selected ? 1.0 : 0.0

                        Behavior on color { ColorAnimation { duration: 200 } }
                        Behavior on opacity { NumberAnimation { duration: 200 } }
                    }
                }
            }
        }

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

            onClicked: Navigation.pop()
        }
    }
}
