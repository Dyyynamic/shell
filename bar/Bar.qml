import Quickshell
import Quickshell.Wayland
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

    Item {
        anchors.fill: parent
        anchors.margins: Theme.spacingTiny

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
                visible: Players.players.length > 0
                active: Players.players.length > 0
                sourceComponent: MediaIndicator {}
            }

            StatusIndicator {
                onClicked: () => ControlCenter.Controller.toggle()
            }
        }
    }
}
