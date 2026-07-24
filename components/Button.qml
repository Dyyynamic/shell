import QtQuick
import QtQuick.Controls
import "../utils"

Button {
    id: root

    property alias textColor: root.palette.buttonText
    property alias radius: background.radius
    property color color: Theme.overlay

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
                return Theme.colorMix(root.color, Theme.text, Theme.pressIntensity)
            if (root.hovered)
                return Theme.colorMix(root.color, Theme.text, Theme.hoverIntensity);
            return root.color;
        }

        Behavior on color {
            ColorAnimation {
                duration: Theme.animDurationShort
                easing.type: Theme.animEasing
            }
        }
    }
}
