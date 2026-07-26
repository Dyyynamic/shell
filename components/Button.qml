import QtQuick
import QtQuick.Controls
import "../utils"

Button {
    id: root

    property alias radius: background.radius

    property color backgroundColor: Theme.overlay
    property color hoveredColor: Theme.colorMix(backgroundColor, Theme.text, Theme.hoverIntensity);
    property color pressedColor: Theme.colorMix(backgroundColor, Theme.text, Theme.pressIntensity);
    property alias backgroundOpacity: background.opacity

    property alias textColor: root.palette.buttonText

    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizeSmall
    font.weight: Font.Medium
    palette.buttonText: Theme.text

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
                duration: Theme.animDurationShort
                easing.type: Theme.animEasing
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Theme.animDurationShort
                easing.type: Theme.animEasing
            }
        }
    }
}
