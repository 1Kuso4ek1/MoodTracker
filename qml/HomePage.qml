import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Effects

import DatabaseManager

ColumnLayout {
    id: root
    spacing: 0

    ToolBar {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignTop
        Layout.preferredHeight: 50

        z: 10

        background: BlurredBackground {
            item: listView
            rect: Qt.rect(-25, -50, listView.width + 25, 50)
        }

        RowLayout {
            anchors.fill: parent

            Label {
                text: "Главная"
                font.pixelSize: 18
                font.bold: true

                Layout.fillWidth: true

                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignHCenter
            }
        }
    }

    signal refresh()

    function loadEntries() {
        listView.model = DatabaseManager.getEntries();
    }

    ListView {
        id: listView

        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 30
        Layout.topMargin: 0
        Layout.bottomMargin: 0
        Layout.alignment: Qt.AlignCenter

        spacing: 30

        cacheBuffer: 1000
        displayMarginBeginning: 100
        displayMarginEnd: 160

        Component.onCompleted: parent.refresh.connect(parent.loadEntries)

        model: DatabaseManager.getEntries()
        delegate: Rectangle {
            id: delegateItem

            required property string entryId
            required property string emoji
            required property string note
            required property string date

            width: listView.width - 50
            height: rowLayout.implicitHeight

            color: "transparent"

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    Navigation.push("NewEntry.qml", { homePage: root, entryId: entryId });
                }

                onPressAndHold: contextMenu.popup()
            }

            Menu {
                id: contextMenu
                MenuItem {
                    text: "Удалить"

                    onClicked: deleteDialog.open()
                }
            }

            Dialog {
                id: deleteDialog
                title: "Удаление"
                standardButtons: Dialog.Yes | Dialog.No

                anchors.centerIn: Overlay.overlay

                Label {
                    text: "Вы действительно хотите удалить запись?"
                }

                onAccepted: {
                    DatabaseManager.deleteEntry(delegateItem.entryId)
                    root.refresh()
                }
            }

            RowLayout {
                id: rowLayout
                anchors.fill: parent

                spacing: 15

                Label {
                    id: emojiLabel

                    Layout.alignment: Qt.AlignVCenter

                    text: delegateItem.emoji

                    font.pixelSize: 50
                    font.family: "Noto Color Emoji [GOOG]"
                }

                ColumnLayout {
                    Layout.fillWidth: true

                    spacing: 5

                    Label {
                        Layout.fillWidth: true

                        text: delegateItem.date

                        font.pixelSize: 12
                        color: Material.foreground
                    }

                    Label {
                        Layout.fillWidth: true

                        text: delegateItem.note

                        font.pixelSize: 18

                        wrapMode: Text.Wrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 100
        z: 10

        BlurredBackground {
            item: listView
            rect: Qt.rect(-25, listView.height, listView.width + 25, 100)
        }

        RoundButton {
            anchors.centerIn: parent

            text: "+"
            font.pixelSize: 24

            width: 80
            height: 80

            onClicked: {
                Navigation.push("NewEntry.qml", { homePage: root });
            }
        }
    }
}
