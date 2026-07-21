import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../utils"
import "../components" as Components

Components.Widget {
    id: root

    signal closeRequested

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
                    font.pixelSize: Theme.fontSizeSmall
                    font.weight: Font.Medium
                }
                Text {
                    visible: Battery.available
                    text: Battery.description
                    color: Theme.text
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeTiny
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        RowLayout {
            spacing: Theme.spacingSmall

            Components.IconButton {
                color: {
                    if (this.pressed)
                        return Qt.lighter(Theme.surface, Theme.pressMultiplier);
                    if (this.hovered)
                        return Qt.lighter(Theme.surface, Theme.hoverMultiplier);
                    return Theme.base;
                }

                iconText: ""
                onClicked: () => {
                    root.closeRequested();
                    betterControl.startDetached();
                }
            }
            Components.IconButton {
                color: {
                    if (this.pressed)
                        return Qt.lighter(Theme.surface, Theme.pressMultiplier);
                    if (this.hovered)
                        return Qt.lighter(Theme.surface, Theme.hoverMultiplier);
                    return Theme.base;
                }
                iconText: ""
                onClicked: () => {
                    root.closeRequested();
                    lockTimer.start();
                }
            }
            Components.IconButton {
                color: {
                    if (this.pressed)
                        return Qt.lighter(Theme.surface, Theme.pressMultiplier);
                    if (this.hovered)
                        return Qt.lighter(Theme.surface, Theme.hoverMultiplier);
                    return Theme.base;
                }
                iconText: ""
                onClicked: () => {
                    root.closeRequested();
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
        id: hyprlock
        command: ["hyprlock"]
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

    Timer {
        id: lockTimer
        interval: Theme.animationDuration
        onTriggered: {
            hyprlock.running = true;
        }
    }
}
