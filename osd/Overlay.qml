pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import "../utils"
import "../components" as Components

PanelWindow {
    id: root
    WlrLayershell.namespace: "qs-osd"

    required property var controller

    property string icon: ""
    property color iconColor: Colors.md3.on_surface

    property string text: ""
    property real value: 0
    property int contentType: Controller.Text

    readonly property real maxWidth: 600
    readonly property real iconSize: 32
    readonly property real spacing: Theme.spacingLarge

    screen: Screens.main

    exclusionMode: ExclusionMode.Ignore
    anchors {
        left: true
        right: true
        bottom: true
    }
    implicitHeight: osd.implicitHeight + 32

    color: "transparent"

    mask: Region {}

    NumberAnimation {
        id: enterAnimation
        target: osd
        property: "opacity"
        from: 0
        to: 1
        duration: Theme.durationMedium
        easing.type: Theme.easingStandard

        // Run immediately
        running: root.controller.overlayVisible
    }

    NumberAnimation {
        id: exitAnimation
        target: osd
        property: "opacity"
        from: 1
        to: 0
        duration: Theme.durationMedium
        easing.type: Theme.easingStandard

        // Fade out before unloading
        running: !root.controller.overlayVisible
        onFinished: root.controller.overlayLoaded = false
    }

    Item {
        id: osd
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }

        implicitWidth: Math.min(content.implicitWidth + root.spacing * 2, root.maxWidth)
        implicitHeight: 64

        Behavior on implicitWidth {
            NumberAnimation {
                duration: Theme.durationMedium
                easing.type: Theme.easingStandard
            }
        }

        Rectangle {
            anchors.fill: parent
            color: Qt.alpha("black", 0.75)
            radius: Theme.radiusLarge
        }

        ClippingRectangle {
            color: "transparent"

            anchors {
                fill: parent
                leftMargin: root.spacing
                rightMargin: root.spacing
            }

            RowLayout {
                id: content
                anchors.fill: parent
                spacing: root.spacing

                Components.Icon {
                    icon: root.icon
                    color: root.iconColor
                    size: root.iconSize
                }

                Text {
                    // Calculate final text width so ellipsis remains static
                    // during OSD resizing
                    readonly property real textWidth: Math.min(implicitWidth, root.maxWidth - root.spacing * 3 - root.iconSize)

                    Layout.preferredWidth: textWidth

                    visible: root.contentType === Controller.Text

                    text: root.text
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeLarge
                    font.weight: Font.Bold
                    color: "#e3e3e3"
                    elide: Text.ElideRight
                }

                Item {
                    id: progressBar
                    visible: root.contentType === Controller.Progress

                    implicitWidth: 160
                    implicitHeight: 8

                    Rectangle {
                        id: progressBarBackground
                        anchors.fill: parent
                        color: Qt.alpha("#e3e3e3", 0.25)
                        radius: height / 2
                    }

                    Rectangle {
                        id: progressBarFill
                        width: parent.width * root.value
                        height: parent.height
                        color: "#e3e3e3"
                        radius: height / 2
                    }
                }
            }
        }
    }
}
