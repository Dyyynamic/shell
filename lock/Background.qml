import QtQuick
import QtQuick.Effects

Item {
    id: root

    required property string wallpaper

    anchors.fill: parent

    Image {
        id: wallpaper
        anchors.fill: parent
        source: root.wallpaper
        fillMode: Image.PreserveAspectCrop
    }

    MultiEffect {
        id: pass1
        anchors.fill: parent
        source: wallpaper

        blurEnabled: true
        blur: 1
        blurMax: 64
        blurMultiplier: 0.25
        autoPaddingEnabled: false
    }

    MultiEffect {
        id: pass2
        anchors.fill: parent
        source: pass1

        blurEnabled: true
        blur: 1
        blurMax: 64
        blurMultiplier: 0.25
        autoPaddingEnabled: false
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.alpha("black", 0.15)
    }
}
