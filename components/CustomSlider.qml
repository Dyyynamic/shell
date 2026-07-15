import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../utils"

Slider {
    id: root

    property int trackHeight: 4
    property int trackRadius: trackHeight / 2
    property int handleHeight: 24
    property int handleWidth: {
        if (root.pressed)
            return 4;
        if (root.hovered)
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
    implicitHeight: handleHeight

    focusPolicy: Qt.NoFocus

    background: ClippingRectangle {
        x: root.leftPadding
        y: root.height / 2 - height / 2
        width: root.availableWidth
        height: root.trackHeight

        color: "transparent"
        radius: root.trackRadius

        ClippingRectangle {
            id: leftRect

            x: 0
            width: root.handleCenter - root.handleWidth / 2 - root.handleGap
            height: parent.height
            color: Theme.accent

            Icon {
                icon: root.icon
                size: root.iconSize
                color: Theme.textAccent
                x: root.width - root.trackHeight / 2 - size / 2
                y: root.trackHeight / 2 - size / 2
            }
        }

        ClippingRectangle {
            id: rightRect

            x: root.handleCenter + root.handleWidth / 2 + root.handleGap
            width: parent.width - x
            height: parent.height
            color: Theme.accentDark

            Icon {
                icon: root.icon
                size: root.iconSize
                color: Theme.text
                x: rightRect.width - root.trackHeight / 2 - size / 2
                y: root.trackHeight / 2 - size / 2
            }
        }
    }

    handle: Rectangle {
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.height / 2 - height / 2

        width: root.handleWidth
        height: root.handleHeight
        radius: width / 2
        color: Theme.accent

        Behavior on width {
            NumberAnimation {
                duration: Theme.animationDurationFast
                easing.type: Theme.animationEasing
            }
        }
    }
}
