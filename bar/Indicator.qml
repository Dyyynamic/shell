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

    property color backgroundColor: Theme.overlay
    property real backgroundOpacity: 1
    property bool showBackgroundImage: true

    signal clicked

    implicitHeight: 32
    implicitWidth: content.implicitWidth + horizontalPadding * 2

    radius: height / 2

    color: "transparent"

    Item {
        id: background
        anchors.fill: parent
        visible: root.showBackgroundImage
    }

    Rectangle {
        anchors.fill: parent
        color: {
            if (root.pressed)
                return Qt.lighter(root.backgroundColor, Theme.pressMult);
            if (root.hovered)
                return Qt.lighter(root.backgroundColor, Theme.hoverMult);
            return root.backgroundColor;
        }
        opacity: root.backgroundOpacity

        Behavior on color {
            ColorAnimation {
                duration: Theme.animDurationShort
                easing.type: Theme.animEasing
            }
        }
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
}
