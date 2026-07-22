import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../utils"
import "../notifs" as Notifs
import "." as ControlCenter

PanelWindow {
    id: root
    WlrLayershell.namespace: "qs-control-center"

    readonly property int margin: Theme.spacingSmall

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    exclusionMode: MarginTypes.Exclusive
    color: "transparent"

    MouseArea {
        anchors.fill: parent
        onClicked: ControlCenter.Controller.close()
    }

    property var enterAnimation: ParallelAnimation {
        NumberAnimation {
            id: fadeIn
            target: wrapperItem
            property: "opacity"
            from: 0
            to: 1
            duration: Theme.animDurationMedium
            easing.type: Theme.animEasing
        }

        NumberAnimation {
            id: slideIn
            target: slideTransform
            property: "x"
            from: wrapperItem.width
            to: 0
            duration: Theme.animDurationMedium
            easing.type: Theme.animEasing
        }

        onFinished: ControlCenter.Controller.transitionFinished()
    }

    property var exitAnimation: ParallelAnimation {
        NumberAnimation {
            id: fadeOut
            target: wrapperItem
            property: "opacity"
            from: 1
            to: 0
            duration: Theme.animDurationMedium
            easing: Theme.animEasing
        }

        NumberAnimation {
            id: slideOut
            target: slideTransform
            property: "x"
            from: 0
            to: wrapperItem.width
            duration: Theme.animDurationMedium
            easing.type: Theme.animEasing
        }

        onFinished: ControlCenter.Controller.transitionFinished()
    }

    WrapperItem {
        id: wrapperItem
        width: 450

        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }

        margin: root.margin

        // Use a transform since x cannot be animated directly
        transform: Translate {
            id: slideTransform
            x: 0
        }

        Item {
            // Prevent clicks inside the panel from closing it
            MouseArea {
                anchors.fill: parent
            }

            RectangularShadow {
                anchors.fill: parent
                radius: background.radius
                color: "black"
                opacity: 0.75
                offset.y: 2
                blur: 20
                z: -1
            }

            Rectangle {
                id: background
                anchors.fill: parent
                radius: Theme.radiusLarge
                color: Theme.base
                border.color: Theme.outline
            }

            WrapperItem {
                anchors.fill: parent
                margin: Theme.spacingMedium

                ColumnLayout {
                    spacing: Theme.spacingMedium
                    width: parent.width
                    height: parent.height

                    ControlCenter.Header {
                        Layout.fillWidth: true
                    }

                    ControlCenter.Settings {
                        Layout.fillWidth: true
                    }

                    Notifs.List {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    ControlCenter.Calendar {
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
