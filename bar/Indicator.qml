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

    property color textColor: Theme.text
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
                return Theme.colorMix(root.backgroundColor, Theme.text, Theme.pressIntensity);
            if (root.hovered)
                return Theme.colorMix(root.backgroundColor, Theme.text, Theme.hoverIntensity);
            return root.backgroundColor;
        }
        opacity: root.backgroundOpacity

        Behavior on color {
            ColorAnimation {
                duration: Theme.durationFast
                easing.type: Theme.easingStandard
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
