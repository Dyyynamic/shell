pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool isRecording: false
    property int recStart: 0
    property int duration: 0

    function updateDuration() {
        if (!root.isRecording)
            return;

        duration = Math.floor(Date.now() / 1000 - recStart);
    }

    function stop() {
        stopRecording.running = true;
    }

    FileView {
        path: Quickshell.env("XDG_RUNTIME_DIR") + "/capture/recording.start"
        watchChanges: true
        blockLoading: true
        onFileChanged: this.reload();

        onLoadFailed: {
            root.isRecording = false;
            root.recStart = 0;
            root.duration = 0;
        }

        onLoaded: {
            root.isRecording = true;
            root.recStart = this.text();
        }
    }

    Timer {
        interval: 1000
        running: root.isRecording
        onTriggered: root.updateDuration()
        repeat: true
    }

    Process {
        id: stopRecording
        command: ["capture", "--stop"]
    }
}
