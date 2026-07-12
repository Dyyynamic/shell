pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool enabled: false
    property string name: ""
    property int signal: 0

    property string icon: {
        if (!enabled)
            return "󰤮";
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

    function toggle() {
        toggleWifi.running = true;
        root.enabled = !root.enabled;
    }

    Process {
        id: toggleWifi
        command: ["nmcli", "radio", "wifi", root.enabled ? "off" : "on"]
    }

    Process {
        id: wifiEnabled
        command: ["nmcli", "radio", "wifi"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.enabled = text.trim() === "enabled";
            }
        }
    }

    Process {
        id: wifiStatus
        command: ["nmcli", "-t", "-f", "ACTIVE,SSID,SIGNAL", "dev", "wifi"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = text.trim().split("\n");
                root.name = "";
                root.signal = 0;

                for (let line of lines) {
                    let [active, ssid, signal] = line.split(":");
                    if (active.trim() === "yes") {
                        root.name = ssid.trim();
                        root.signal = parseInt(signal.trim());
                        break;
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
            wifiEnabled.running = true;
            wifiStatus.running = true;
        }
    }
}
