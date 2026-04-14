pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Scope {
    id: brightness

    property int value: 100
    property int max: 100
    property bool backlight: false

    function setBrightness(value: int) {
        brightness.value = value;
        setBrightness.running = true;
    }

    Process {
        id: setBrightness
        command: ["brightnessctl", "--class", "backlight", "set", `${brightness.value}%`]
    }

    Process {
        id: getMax
        command: ["brightnessctl", "--class", "backlight", "max"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                brightness.max = parseInt(text);
            }
        }
    }

    Process {
        id: getBrightness
        command: ["brightnessctl", "--class", "backlight", "get"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let newValue = parseInt(parseInt(text) / brightness.max * 100);
                brightness.value = newValue;
            }
        }
    }

    Process {
        id: backlightExists
        command: ["brightnessctl", "--class", "backlight", "info"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                brightness.backlight = text.trim() !== "";
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            getMax.running = true;
            getBrightness.running = true;
        }
    }
}
