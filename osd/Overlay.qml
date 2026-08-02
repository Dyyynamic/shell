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

    screen: Screens.main

    exclusionMode: ExclusionMode.Ignore
    anchors {
        left: true
        right: true
        bottom: true
    }
    implicitHeight: content.implicitHeight + 32

    color: "transparent"

    mask: Region {}

    NumberAnimation {
        id: enterAnimation
        target: content
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
        target: content
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
        id: content
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }

        implicitWidth: row.implicitWidth + Theme.spacingLarge * 2
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

        WrapperItem {
            anchors.fill: parent
            margin: Theme.spacingLarge

            ClippingRectangle {
                color: "transparent"

                RowLayout {
                    id: row
                    anchors.fill: parent

                    spacing: Theme.spacingLarge

                    Components.Icon {
                        icon: root.icon
                        color: root.iconColor
                        size: 32
                    }

                    Text {
                        visible: root.contentType === Controller.Text

                        text: root.text
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeLarge
                        font.weight: Font.Bold
                        color: "#e3e3e3"
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
}
