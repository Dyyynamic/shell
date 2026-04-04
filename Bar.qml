import Quickshell
import Quickshell.Widgets
import QtQuick
import "components"

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar

            required property var modelData

            screen: modelData
            color: contentItem.palette.window

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
                    }
                }
            }
        }
    }
}
