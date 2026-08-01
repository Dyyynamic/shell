import QtQuick
import QtQuick.Controls
import "../utils"
import "." as Components

Button {
    id: root

    property int size: 40

    property color backgroundColor: Colors.md3.surface_container_high
    property color hoveredColor: Theme.colorMix(backgroundColor, Colors.md3.on_surface, Theme.hoverIntensity);
    property color pressedColor: Theme.colorMix(backgroundColor, Colors.md3.on_surface, Theme.pressIntensity);
    property alias backgroundOpacity: background.opacity

    property alias iconText: icon.icon
    property alias iconSize: icon.size
    property alias iconColor: icon.color

    implicitWidth: size
    implicitHeight: size

    hoverEnabled: enabled
    opacity: enabled > 0 ? 1 : 0.5

    Components.Icon {
        id: icon
        anchors.centerIn: parent
    }

    background: Rectangle {
        id: background
        anchors.fill: parent
        radius: height / 2

        color: {
            if (root.pressed)
                return root.pressedColor;
            if (root.hovered)
                return root.hoveredColor;
            return root.backgroundColor;
        }

        Behavior on color {
            ColorAnimation {
                duration: Theme.durationFast
                easing.type: Theme.easingStandard
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Theme.durationFast
                easing.type: Theme.easingStandard
            }
        }
    }
}
