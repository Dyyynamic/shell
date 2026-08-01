import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../utils"
import "../controlCenter" as ControlCenter
import "../capture" as Capture

PanelWindow {
    id: root
    WlrLayershell.namespace: "qs-bar"

    color: Colors.md3.background

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
                    visible: Capture.Controller.isRecording
                    active: Capture.Controller.isRecording
                    sourceComponent: RecordingIndicator {
                        onClicked: () => Capture.Controller.stopRecording()
                    }
                }

                Loader {
                    visible: Players.hasActivePlayer
                    active: Players.hasActivePlayer
                    sourceComponent: MediaIndicator {}
                }

                StatusIndicator {
                    Layout.preferredWidth: implicitWidth + 8
                    onClicked: () => ControlCenter.Controller.toggle()
                }
            }
        }
    }
}
