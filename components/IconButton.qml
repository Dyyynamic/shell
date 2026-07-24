import QtQuick
import QtQuick.Controls
import "../utils"
import "." as Components

Button {
    id: root

    property alias iconText: icon.icon
    property alias color: background.color

    property int size: 40
    property int iconSize: 20

    implicitWidth: size
    implicitHeight: size

    Components.Icon {
        id: icon
        anchors.centerIn: parent
        color: Theme.text
        size: root.iconSize
    }

    background: Rectangle {
        id: background
        anchors.fill: parent
        radius: height / 2
        color: {
            if (root.pressed)
                return Theme.colorMix(Theme.overlay, Theme.text, Theme.pressIntensity);
            if (root.hovered)
                return Theme.colorMix(Theme.overlay, Theme.text, Theme.hoverIntensity);
            return Theme.overlay;
        }

        Behavior on color {
            ColorAnimation {
                duration: Theme.animDurationShort
                easing.type: Theme.animEasing
            }
        }
    }
}
