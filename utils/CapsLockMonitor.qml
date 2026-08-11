import Quickshell.Io
import QtQuick

Item {
    id: root

    property bool capsLock: false

    // Too Expensive!
    Process {
        running: true
        onRunningChanged: if (!running)
            running = true

        command: ["hyprctl", "-j", "devices"]

        stdout: StdioCollector {
            onStreamFinished: {
                const devices = JSON.parse(this.text);
                const mainKeyboard = devices.keyboards.find(kb => {
                    return kb.main == true;
                });
                root.capsLock = mainKeyboard?.capsLock;
            }
        }
    }
}
