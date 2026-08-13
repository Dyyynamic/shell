import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../utils"
import "../components" as Components
import "../lock" as Lock
import "." as ControlCenter

Components.Widget {
    id: root

    bottomMargin: 0
    backgroundColor: "transparent"

    RowLayout {
        width: parent.width
        spacing: Theme.spacingSmall

        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingSmall

            Components.Icon {
                icon: "󰣇"
                size: 24
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                Text {
                    Layout.fillWidth: true
                    id: uptimeText
                    color: Colors.md3.on_surface
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeMedium
                    font.weight: Font.Medium
                }

                Text {
                    Layout.fillWidth: true
                    visible: Battery.available
                    text: Battery.description
                    color: Colors.md3.on_surface
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                }
            }
        }

        RowLayout {
            spacing: Theme.spacingSmall
            Layout.alignment: Qt.AlignRight

            Components.IconButton {
                id: settingsButton

                backgroundColor: Colors.md3.surface_container_low
                backgroundOpacity: hovered ? 1 : 0

                iconGlyph: ""
                onClicked: () => {
                    ControlCenter.Controller.close();
                    betterControl.startDetached();
                }
            }

            Components.Tooltip {
                target: settingsButton
                text: "Settings"
            }

            Components.IconButton {
                id: lockButton

                backgroundColor: Colors.md3.surface_container_low
                backgroundOpacity: hovered ? 1 : 0

                iconGlyph: ""
                onClicked: () => ControlCenter.Controller.closeWithAction(Lock.Controller.lock)
            }

            Components.Tooltip {
                target: lockButton
                text: "Lock"
            }

            Components.IconButton {
                id: systemButton

                backgroundColor: Colors.md3.surface_container_low
                backgroundOpacity: hovered ? 1 : 0

                iconGlyph: ""
                onClicked: () => {
                    ControlCenter.Controller.close();
                    systemMenu.running = true;
                }
            }

            Components.Tooltip {
                target: systemButton
                text: "System"
            }
        }
    }

    Process {
        id: systemMenu
        command: ["walker", "--provider", "menus:system"]
    }

    Process {
        id: betterControl
        command: ["better-control"]
    }

    Process {
        id: uptime
        command: ["cat", "/proc/uptime"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let [uptime, idle] = text.split(" ");

                let hours = Math.floor(uptime / 3600);
                let minutes = Math.floor((uptime % 3600) / 60);
                uptimeText.text = `Up ${hours}h, ${minutes}m`;
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            uptime.running = true;
        }
    }
}
