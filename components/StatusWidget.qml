import QtQuick
import Quickshell.Io
import Quickshell.Services.Pipewire

Widget {
    id: statusWidget

    property string networkType: ""

    onClicked: () => betterControl.startDetached()
    width: implicitWidth + 8

    function networkIcon(signal) {
        if (statusWidget.networkType === "wifi") {
            if (signal > 80)
                return "󰤨";
            if (signal > 60)
                return "󰤥";
            if (signal > 40)
                return "󰤢";
            if (signal > 20)
                return "󰤟";
            return "󰤯";
        }
        if (statusWidget.networkType === "ethernet") {
            return "󰈀";
        }
        return "󰤮";
    }

    Row {
        spacing: 8

        Icon {
            id: network
            icon: "󰤮"
        }

        Icon {
            icon: {
                if (!Pipewire.defaultAudioSink)
                    return "";
                if (Pipewire.defaultAudioSink.audio.muted)
                    return "";
                if (Pipewire.defaultAudioSink.audio.volume > 0.67)
                    return "";
                if (Pipewire.defaultAudioSink.audio.volume > 0.33)
                    return "";
                return "";
            }

            PwObjectTracker {
                objects: [Pipewire.defaultAudioSink]
            }
        }
    }

    Process {
        id: betterControl
        command: ["better-control"]
    }

    Process {
        id: wifiProc
        command: ["nmcli", "-t", "-f", "IN-USE,SIGNAL", "dev", "wifi"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.split("\n");

                for (let line of lines) {
                    const [inUse, signal] = line.split(":");

                    if (inUse.startsWith("*")) {
                        network.icon = statusWidget.networkIcon(signal);
                        break;
                    }
                }
            }
        }
    }

    Process {
        id: networkTypeProc
        command: ["nmcli", "-t", "-f", "TYPE,STATE", "dev"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.split("\n");

                for (let line of lines) {
                    const [type, state] = line.split(":");

                    if (type === "wifi" && state === "connected") {
                        statusWidget.networkType = "wifi";
                        break;
                    } else if (type === "ethernet" && state === "connected") {
                        statusWidget.networkType = "ethernet";
                        break;
                    } else {
                        statusWidget.networkType = "";
                    }
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            wifiProc.running = true;
            networkTypeProc.running = true;
        }
    }
}
