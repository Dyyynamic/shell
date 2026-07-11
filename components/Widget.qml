import Quickshell.Widgets
import QtQuick
import "../utils"

ClippingRectangle {
    id: widget

    default property alias contentData: content.data
    property alias backgroundData: background.data

    property int horizontalPadding: 8
    property bool clickable: false

    signal clicked

    implicitHeight: 32
    implicitWidth: content.implicitWidth + horizontalPadding * 2

    radius: height / 2

    color: {
        if (mouseArea.pressed)
            return Qt.lighter(Colors.md3.background, 3);
        if (mouseArea.containsMouse)
            return Qt.lighter(Colors.md3.background, 2.5);
        return Qt.lighter(Colors.md3.background, 2);
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

        enabled: widget.clickable
        hoverEnabled: true

        onClicked: widget.clicked()
    }

    Behavior on color {
        ColorAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
}
