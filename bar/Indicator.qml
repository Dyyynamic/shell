import Quickshell.Widgets
import QtQuick
import "../utils"

ClippingRectangle {
    id: root

    default property alias contentData: content.data
    property alias backgroundData: background.data

    property alias pressed: mouseArea.pressed
    property alias hovered: mouseArea.containsMouse

    property alias margin: wrapper.margin
    property alias leftMargin: wrapper.leftMargin
    property alias rightMargin: wrapper.rightMargin

    property bool clickable: false

    property color textColor: Theme.text
    property color backgroundColor: Theme.overlay
    property real backgroundOpacity: 1
    property bool showBackgroundImage: true

    property real pressIntensity: Theme.pressIntensity
    property real hoverIntensity: Theme.hoverIntensity

    signal clicked

    implicitHeight: 32
    implicitWidth: wrapper.implicitWidth

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
                return Theme.colorMix(root.backgroundColor, root.textColor, root.pressIntensity);
            if (root.hovered)
                return Theme.colorMix(root.backgroundColor, root.textColor, root.hoverIntensity);
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

    WrapperItem {
        id: wrapper
        anchors.centerIn: parent
        margin: Theme.spacingSmall

        Item {
            id: content
            implicitHeight: childrenRect.height
            implicitWidth: childrenRect.width
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        enabled: root.clickable
        hoverEnabled: true

        onClicked: root.clicked()
    }
}
