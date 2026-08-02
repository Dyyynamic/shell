pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property real value: 1
    property bool backlight: false

    function setBrightness(value: real) {
        root.value = value;
        setBrightness.running = true;
    }

    Process {
        id: setBrightness
        command: ["brightnessctl", "--class", "backlight", "set", `${Math.round(root.value * 100)}%`]
    }

    Process {
        id: backlightExists
        command: ["brightnessctl", "--class", "backlight"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.backlight = text.trim() !== "";
            }
        }
    }

    Process {
        command: ["udevadm", "monitor", "--subsystem-match=backlight", "--udev"]
        running: true
        stdout: SplitParser {
            onRead: updateBrightness.running = true
        }
    }

    Process {
        id: updateBrightness
        command: ["brightnessctl", "-m"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.value = text.split(",")[3].replace("%", "") / 100;
            }
        }
    }
}
