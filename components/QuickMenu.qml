import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../utils"

PanelWindow {
    id: root

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
    screen: bar.screen

    onVisibleChanged: if (!visible)
        calendar.reset()

    MouseArea {
        anchors.fill: parent
        onClicked: root.open = false
    }

    Item {
        id: panelContainer

        width: 450
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }

        // Prevent clicks inside the panel from closing it
        MouseArea {
            anchors.fill: parent
        }

        WrapperItem {
            width: parent.width
            height: parent.height
            topMargin: root.margin
            rightMargin: root.margin
            bottomMargin: root.margin

            Item {
                height: parent.height
                width: parent.width

                opacity: root.open ? 1 : 0
                x: root.open ? 0 : width

                Behavior on opacity {
                    NumberAnimation {
                        duration: Theme.animationDuration
                        easing.type: Theme.animationEasing
                        onRunningChanged: root.transitioning = running
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

                        QuickMenuHeader {
                            Layout.fillWidth: true
                            onMenuClosed: root.open = false
                        }

                        QuickMenuToggles {
                            Layout.fillWidth: true
                        }

                        NotificationList {
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
    }

    Shortcut {
        sequence: "Escape"
        enabled: root.open
        onActivated: root.open = false
    }
}
