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
                return Qt.lighter(root.color, Theme.pressMultiplier);
            if (root.hovered)
                return Qt.lighter(root.color, Theme.hoverMultiplier);
            return root.color;
        }

        Behavior on color {
            ColorAnimation {
                duration: Theme.animationDuration
                easing.type: Theme.animationEasing
            }
        }
    }
}
