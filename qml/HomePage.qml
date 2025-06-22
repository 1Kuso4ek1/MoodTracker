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

    ListModel {
        id: listModel

        /*ListElement { emoji: "🤩"; note: "Сходил на живой концерт любимой группы — адреналина и счастья хватит надолго"; date: "Сегодня" }
        ListElement { emoji: "😄"; note: "Встретился с друзьями в кафе, болтал и смеялся до упаду"; date: "Вчера" }
        ListElement { emoji: "🙂"; note: "Спокойно поработал дома, привёл в порядок рабочую почту и документы"; date: "2 дня назад" }
        ListElement { emoji: "😐"; note: "Целый день занимался рутинной отчётностью в офисе без особых эмоций"; date: "3 дня назад" }
        ListElement { emoji: "😕"; note: "Потерял ключи и провёл пару часов в поисках, так и не найдя их"; date: "4 дня назад" }
        ListElement { emoji: "🙁"; note: "Отменили долгожданную встречу, планы рухнули"; date: "5 дней назад" }
        ListElement { emoji: "😠"; note: "Спорил с интернет-провайдером из-за постоянных сбоев связи"; date: "6 дней назад" }
        ListElement { emoji: "😫"; note: "Дорабатывал срочный проект до поздней ночи, едва держась на ногах"; date: "7 дней назад" }
        ListElement { emoji: "😭"; note: "Отвёз питомца к ветеринару на тяжёлую процедуру и очень переживал"; date: "8 дней назад" }*/
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

        Component.onCompleted: refresh.connect(loadEntries)

        model: DatabaseManager.getEntries()
        delegate: RowLayout {
            id: rowLayout

            required property string emoji
            required property string note
            required property string date

            spacing: 15
            width: parent.width - 50

            Label {
                Layout.alignment: Qt.AlignVCenter

                text: rowLayout.emoji
                font.pixelSize: 50

                font.family: "Noto Color Emoji [GOOG]"
            }

            ColumnLayout {
                Layout.fillWidth: true

                Label {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true

                    text: rowLayout.date
                    font.pixelSize: 12

                    color: Material.foreground
                }

                Label {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true

                    text: rowLayout.note
                    font.pixelSize: 18
                    wrapMode: Text.Wrap
                    maximumLineCount: 2

                    elide: Text.ElideRight
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
