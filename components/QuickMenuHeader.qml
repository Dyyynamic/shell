import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../utils"

RowLayout {
    id: quickMenuHeader

    spacing: 10

    signal menuClosed

    RowLayout {
        spacing: 10

        Icon {
            icon: "󰣇"
            size: 24
        }
        ColumnLayout {
            spacing: 0
            Text {
                id: uptimeText
                color: Colors.md3.on_background
                font.family: "NotoSans Nerd Font Propo"
                font.pixelSize: 14
            }
            Text {
                visible: Battery.available
                text: Battery.description
                color: Colors.md3.on_background
                font.family: "NotoSans Nerd Font Propo"
                font.pixelSize: 12
            }
        }
    }

    Item {
        Layout.fillWidth: true
    }

    RowLayout {
        spacing: 10

        IconButton {
            iconText: ""
            onClicked: () => {
                quickMenuHeader.menuClosed();
                betterControl.startDetached();
            }
        }
        IconButton {
            iconText: ""
            onClicked: () => {
                quickMenuHeader.menuClosed();
                powerMenu.running = true;
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
