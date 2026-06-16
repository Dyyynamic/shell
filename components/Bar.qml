import Quickshell
import Quickshell.Widgets
import QtQuick
import "../utils"

Scope {
    id: root
    property string mainMonitor: Quickshell.env("MAIN_MONITOR")

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
                    StatusWidget {
                        anchors.right: parent.right
                        onClicked: () => quickMenu.open = !quickMenu.open
                    }
                }
            }

            QuickMenu {
                id: quickMenu
                bar: bar
            }

            // Show if the screen is the main monitor
            NotificationPopupStack {
                id: notificationPopupStack
                bar: bar
                visible: bar.modelData.name === root.mainMonitor
            }
        }
    }
}
