import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import "../utils"

Slider {
    id: slider

    property alias icon: icon.icon

    from: 0
    to: 100
    value: 50

    implicitHeight: 38

    background: ClippingRectangle {
        x: slider.leftPadding
        y: slider.height / 2 - height / 2
        width: slider.availableWidth
        height: 30
        radius: 8
        color: Colors.md3.on_secondary

        // Filled part
        Rectangle {
            width: slider.visualPosition * parent.width
            height: parent.height
            color: Colors.md3.primary
            radius: 0
        }
    }

    handle: Rectangle {
        x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
        y: slider.height / 2 - height / 2

        width: {
            if (slider.pressed) return 12;
            if (slider.hovered) return 14;
            return 12;
        }
        height: 46
        radius: 6
        color: Colors.md3.primary

        border.color: Colors.md3.background
        border.width: 4

        Behavior on width {
            NumberAnimation {
                duration: 100
                easing.type: Easing.OutCubic
            }
        }
    }

    Icon {
        id: icon
        color: {
            if (slider.value / slider.to > 0.97)
                return Colors.md3.on_primary;
            return Colors.md3.on_background;
        }
        size: 16
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 8
    }
}
