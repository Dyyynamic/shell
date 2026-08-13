import Quickshell.Widgets
import QtQuick
import "../utils"

ClippingRectangle {
    id: root

    default property alias contentData: content.data
    property alias backgroundData: background.data

    property alias pressed: mouseArea.pressed
    property alias hovered: mouseArea.containsMouse

    property alias margin: content.anchors.margins
    property alias leftMargin: content.anchors.leftMargin
    property alias rightMargin: content.anchors.rightMargin

    property bool clickable: false

    property color textColor: Colors.md3.on_surface
    property color backgroundColor: Colors.md3.surface_container_high
    property real backgroundOpacity: 1
    property bool showBackgroundImage: true

    property real pressIntensity: Theme.pressIntensity
    property real hoverIntensity: Theme.hoverIntensity

    signal clicked

    implicitHeight: 32
    implicitWidth: content.implicitWidth + leftMargin + rightMargin

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

    Item {
        id: content

        implicitHeight: childrenRect.height
        implicitWidth: childrenRect.width

        anchors {
            fill: parent
            margins: Theme.spacingSmall

            // Set explicitly so root.margin does not override
            topMargin: 0
            bottomMargin: 0
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
