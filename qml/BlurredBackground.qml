import QtQuick
import QtQuick.Controls.Material
import QtQuick.Effects

Rectangle {
    required property var item
    required property var rect

    anchors.fill: parent
    color: Material.background

    ShaderEffectSource {
        id: blurSource
        sourceItem: parent.item
        sourceRect: parent.rect
        live: true
        hideSource: false
        visible: false
        anchors.fill: parent
    }

    MultiEffect {
        source: blurSource
        blurEnabled: true
        blur: 1.0
        blurMax: 32
        anchors.fill: parent
    }
}
