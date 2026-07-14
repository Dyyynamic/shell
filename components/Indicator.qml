import Quickshell.Widgets
import QtQuick
import "../utils"

ClippingRectangle {
    id: root

    default property alias contentData: content.data
    property alias backgroundData: background.data

    property alias pressed: mouseArea.pressed
    property alias hovered: mouseArea.containsMouse

    property int horizontalPadding: 8
    property bool clickable: false

    signal clicked

    implicitHeight: 32
    implicitWidth: content.implicitWidth + horizontalPadding * 2

    radius: height / 2

    color: {
        if (pressed)
            return Qt.lighter(Theme.overlay, Theme.pressedMultiplier);
        if (hovered)
            return Qt.lighter(Theme.overlay, Theme.hoverMultiplier);
        return Theme.overlay;
    }

    Item {
        id: background
        anchors.fill: parent
    }

    Item {
        id: content
        anchors.centerIn: parent

        implicitHeight: childrenRect.height
        implicitWidth: childrenRect.width
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        enabled: root.clickable
        hoverEnabled: true

        onClicked: root.clicked()
    }

    Behavior on color {
        ColorAnimation {
            duration: Theme.animationDuration
            easing.type: Theme.animationEasing
        }
    }
}
