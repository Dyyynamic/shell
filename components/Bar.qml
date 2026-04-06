import Quickshell
import Quickshell.Widgets
import QtQuick
import "../utils"

Scope {
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

            height: 40

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
            }
        }
    }
}
