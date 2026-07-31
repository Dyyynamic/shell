import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../utils"
import "../components" as Components
import "../lock" as Lock
import "." as ControlCenter

Components.Widget {
    id: root

    contentBottomMargin: 0
    backgroundColor: "transparent"

    RowLayout {
        spacing: Theme.spacingSmall

        RowLayout {
            spacing: Theme.spacingSmall

            Components.Icon {
                icon: "󰣇"
                size: 24
            }
            ColumnLayout {
                spacing: 0
                Text {
                    id: uptimeText
                    color: Theme.text
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeMedium
                    font.weight: Font.Medium
                }
                Text {
                    visible: Battery.available
                    text: Battery.description
                    color: Theme.text
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        RowLayout {
            spacing: Theme.spacingSmall

            Components.IconButton {
                backgroundColor: Theme.surface
                backgroundOpacity: hovered ? 1 : 0

                iconText: ""
                onClicked: () => {
                    ControlCenter.Controller.close();
                    betterControl.startDetached();
                }
            }
            Components.IconButton {
                backgroundColor: Theme.surface
                backgroundOpacity: hovered ? 1 : 0

                iconText: ""
                onClicked: () => ControlCenter.Controller.closeWithAction(Lock.Controller.lock)
            }
            Components.IconButton {
                backgroundColor: Theme.surface
                backgroundOpacity: hovered ? 1 : 0

                iconText: ""
                onClicked: () => {
                    ControlCenter.Controller.close();
                    powerMenu.running = true;
                }
            }
        }
    }

    Process {
        id: powerMenu
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
