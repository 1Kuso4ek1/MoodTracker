import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import DatabaseManager

ColumnLayout {
    id: root
    spacing: 0

    property int entryId: 0
    required property Item homePage

    Layout.fillHeight: true

    function loadData() {
        const data = DatabaseManager.getEntryById(entryId)
        if(data) {
            repeater.selectedIndex = repeater.model.indexOf(data.emoji)
            noteField.text = data.note
        }
    }

    Component.onCompleted: {
        if(entryId > 0) {
            loadData()
            headerLabel.text = "Редактирование записи"
        }
        else
            headerLabel.text = "Добавить запись"
    }

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

                width: 50
                height: 50

                onClicked: Navigation.pop()

                Layout.alignment: Qt.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            Label {
                id: headerLabel
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
            font.weight: 300

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
        }

        RowLayout {
            id: rowLayout

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter

            spacing: 5

            Repeater {
                id: repeater

                property var selectedIndex: 2

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter

                model: [ "😀", "😐", "😕", "😞", "😠" ]

                RoundButton {
                    id: emojiButton

                    flat: true

                    required property string modelData
                    required property int index

                    text: modelData
                    font.family: "Noto Color Emoji [GOOG]"
                    font.pixelSize: 35

                    Layout.alignment: Qt.AlignHCenter

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
            id: noteField

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 100

            wrapMode: Text.Wrap

            placeholderText: "Как прошел ваш день?"
        }

        Button {
            Layout.alignment: Qt.AlignHCenter

            text: "Сохранить"
            font.pixelSize: 18

            onClicked: {
                if(entryId > 0)
                    DatabaseManager.editEntry(entryId, repeater.model[repeater.selectedIndex], noteField.text)
                else
                    DatabaseManager.addEntry(repeater.model[repeater.selectedIndex], noteField.text)
                homePage.refresh()
                Navigation.pop()
            }
        }
    }
}
