import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "../utils"

Scope {
    id: root
    property string mainMonitor: Quickshell.env("MAIN_MONITOR") || ""

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar

            required property var modelData

            screen: modelData
            color: Colors.md3.background

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 40

            WrapperItem {
                anchors.fill: parent
                margin: 4

                Item {
                    WorkspaceWidget {
                        anchors.left: parent.left
                        screen: bar.modelData
                    }

                    ClockWidget {
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    RowLayout {
                        anchors.right: parent.right
                        spacing: 4

                        MediaWidget {}

                        StatusWidget {
                            Layout.preferredWidth: implicitWidth + 8
                            onClicked: () => quickMenu.open = !quickMenu.open
                        }
                    }
                }
            }

            QuickMenu {
                id: quickMenu
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
                name: "toggleQuickMenu"
                description: "Toggle Quick Menu"
                onPressed: {
                    // Show on the focused monitor
                    if (Hyprland.focusedMonitor.name === bar.modelData.name) {
                        quickMenu.open = !quickMenu.open;
                    }
                }
            }
        }
    }
}
