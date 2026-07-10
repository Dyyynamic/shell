import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../utils"

Slider {
    id: slider

    property int trackHeight: 4
    property int trackRadius: trackHeight / 2
    property int handleHeight: 24
    property int handleWidth: {
        if (slider.pressed)
            return 4;
        if (slider.hovered)
            return 6;
        return 4;
    }

    property string icon: ""
    property int iconSize: 16

    readonly property int handleGap: 4
    readonly property real handleCenter: handle.x + handle.width / 2

    from: 0
    to: 100
    value: 50

    Layout.fillWidth: true
    implicitHeight: 40

    focusPolicy: Qt.NoFocus

    background: ClippingRectangle {
        x: slider.leftPadding
        y: slider.height / 2 - height / 2
        width: slider.availableWidth
        height: slider.trackHeight

        color: "transparent"
        radius: slider.trackRadius

        ClippingRectangle {
            id: leftRect

            x: 0
            width: slider.handleCenter - slider.handleWidth / 2 - slider.handleGap
            height: parent.height
            color: Colors.md3.primary

            Icon {
                icon: slider.icon
                size: slider.iconSize
                color: Colors.md3.on_primary
                x: slider.width - slider.trackHeight / 2 - size / 2
                y: slider.trackHeight / 2 - size / 2
            }
        }

        ClippingRectangle {
            id: rightRect

            x: slider.handleCenter + slider.handleWidth / 2 + slider.handleGap
            width: parent.width - x
            height: parent.height
            color: Colors.md3.on_secondary

            Icon {
                icon: slider.icon
                size: slider.iconSize
                color: Colors.md3.on_background
                x: rightRect.width - slider.trackHeight / 2 - size / 2
                y: slider.trackHeight / 2 - size / 2
            }
        }
    }

    handle: Rectangle {
        x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
        y: slider.height / 2 - height / 2

        width: slider.handleWidth
        height: slider.handleHeight
        radius: width / 2
        color: Colors.md3.primary
    }
}
