pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property int value: 100
    property bool backlight: false

    function setBrightness(value: int) {
        root.value = value;
        setBrightness.running = true;
    }

    Process {
        id: setBrightness
        command: ["brightnessctl", "--class", "backlight", "set", `${root.value}%`]
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
                root.value = this.text.split(",")[3].replace("%", "");
            }
        }
    }
}
