import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../utils"
import "../notifs" as Notifs

PanelWindow {
    id: root
    WlrLayershell.namespace: "qs-control-center"

    required property var bar

    readonly property int margin: Theme.spacingSmall

    property bool open: false
    property bool transitioning: false

    visible: open || transitioning
    focusable: visible

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    margins.top: bar.height
    exclusionMode: ExclusionMode.Ignore
    implicitWidth: screen.width
    color: "transparent"

    onVisibleChanged: if (!visible)
        calendar.reset()

    MouseArea {
        anchors.fill: parent
        onClicked: root.open = false
    }

    WrapperItem {
        width: 450

        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }

        margin: root.margin

        Item {
            // Prevent clicks inside the panel from closing it
            MouseArea {
                anchors.fill: parent
            }

            opacity: root.open ? 1 : 0
            x: root.open ? root.margin : width

            Behavior on opacity {
                NumberAnimation {
                    duration: Theme.animationDuration
                    easing.type: Theme.animationEasing
                    onRunningChanged: {
                        root.transitioning = running;

                        // Close the menu only if the animation has finished
                        // and the menu is closed
                        if (!running && !root.open) {
                            settings.closeSilent();
                        }
                    }
                }
            }

            Behavior on x {
                NumberAnimation {
                    duration: Theme.animationDuration
                    easing.type: Theme.animationEasing
                    onRunningChanged: root.transitioning = running
                }
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

                    Header {
                        Layout.fillWidth: true
                        onCloseRequested: root.open = false
                    }

                    Settings {
                        id: settings
                        Layout.fillWidth: true
                        onCloseRequested: root.open = false
                    }

                    Notifs.List {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        onNotificationActivated: root.open = false
                    }

                    CustomCalendar {
                        id: calendar
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }

    Shortcut {
        sequence: "Escape"
        enabled: root.open
        onActivated: root.open = false
    }
}
