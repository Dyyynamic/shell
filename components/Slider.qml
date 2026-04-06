import QtQuick
import QtQuick.Controls
import "../utils"

Slider {
    id: slider

    property alias icon: icon.icon

    from: 0
    to: 100
    value: 50

    implicitHeight: 32

    background: Rectangle {
        x: slider.leftPadding
        y: slider.height / 2 - height / 2
        width: slider.availableWidth
        height: 28
        radius: 8
        color: Colors.md3.on_secondary

        // Filled part
        Rectangle {
            width: slider.visualPosition * parent.width
            height: parent.height
            color: Colors.md3.primary
            radius: 8
        }
    }

    handle: Rectangle {
        x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
        y: slider.height / 2 - height / 2

        width: 12
        height: 40
        radius: 6
        color: Colors.md3.primary

        border.color: Colors.md3.background
        border.width: 4
    }

    Icon {
        id: icon
        color: Colors.md3.on_background
        size: 16
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 8
    }
}
