import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../utils"

PanelWindow {
    id: root

    required property var bar

    readonly property int margin: 10

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
                        duration: 200
                        easing.type: Easing.OutCubic
                        onRunningChanged: root.transitioning = running
                    }
                }

                Behavior on x {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutQuad
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
                    radius: 20
                    color: Colors.md3.background
                    border.color: Qt.lighter(Colors.md3.background, 1.5)

                    WrapperItem {
                        id: wrapper
                        width: parent.width
                        height: parent.height
                        margin: 20

                        ColumnLayout {
                            spacing: 20
                            width: parent.width
                            height: parent.height

                            QuickMenuHeader {
                                onMenuClosed: root.open = false
                            }

                            QuickMenuSliders {}

                            QuickMenuToggles {}

                            NotificationList {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                onNotificationActivated: root.open = false
                            }

                            CustomCalendar {
                                id: calendar
                            }
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
