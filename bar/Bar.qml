import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../utils"

PanelWindow {
    id: root
    WlrLayershell.namespace: "qs-bar"

    signal controlCenterToggleRequested

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
                screen: root.screen
            }

            ClockIndicator {
                anchors.horizontalCenter: parent.horizontalCenter
            }

            RowLayout {
                anchors.right: parent.right
                spacing: Theme.spacingTiny

                Loader {
                    active: Players.hasActivePlayer
                    sourceComponent: MediaIndicator {}
                }

                StatusIndicator {
                    Layout.preferredWidth: implicitWidth + 8
                    onClicked: () => root.controlCenterToggleRequested()
                }
            }
        }
    }
}
