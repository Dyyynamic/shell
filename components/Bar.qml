import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../utils"

Scope {
    id: root

    readonly property string mainMonitor: Quickshell.env("MAIN_MONITOR") || ""

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar

            required property var modelData

            screen: modelData
            color: Theme.base

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 40

            WrapperItem {
                anchors.fill: parent
                margin: Theme.spacingTiny

                Item {
                    WorkspaceIndicator {
                        anchors.left: parent.left
                        screen: bar.modelData
                    }

                    ClockIndicator {
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    RowLayout {
                        anchors.right: parent.right
                        spacing: Theme.spacingTiny

                        Loader {
                            active: PlayerStore.hasActivePlayer
                            sourceComponent: MediaIndicator {}
                        }

                        StatusIndicator {
                            Layout.preferredWidth: implicitWidth + 8
                            onClicked: () => controlCenter.open = !controlCenter.open
                        }
                    }
                }
            }

            ControlCenter {
                id: controlCenter
                bar: bar
            }

            NotificationPopupStack {
                id: notificationPopupStack
                bar: bar
                // Show on the main monitor if MAIN_MONITOR is set,
                // otherwise show on all monitors
                visible: !root.mainMonitor || bar.modelData.name === root.mainMonitor
            }

            GlobalShortcut {
                name: "toggleControlCenter"
                description: "Toggle Control Center"
                onPressed: {
                    // Show on the focused monitor
                    if (Hyprland.focusedMonitor.name === bar.modelData.name) {
                        controlCenter.open = !controlCenter.open;
                    }
                }
            }
        }
    }
}
