import QtQuick
import QtQuick.Controls
import "../utils"

Button {
    id: root

    property alias radius: background.radius

    property color backgroundColor: Colors.md3.surface_container_high
    property color hoveredColor: Theme.colorMix(backgroundColor, Colors.md3.on_surface, Theme.hoverIntensity);
    property color pressedColor: Theme.colorMix(backgroundColor, Colors.md3.on_surface, Theme.pressIntensity);
    property alias backgroundOpacity: background.opacity

    property alias textColor: root.palette.buttonText

    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizeSmall
    font.weight: Font.Medium
    palette.buttonText: Colors.md3.on_surface

    implicitHeight: 32
    horizontalPadding: Theme.spacingMedium

    hoverEnabled: enabled
    opacity: enabled > 0 ? 1 : 0.5

    background: Rectangle {
        id: background
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
