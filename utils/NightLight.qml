pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property var states: ["day", "night", "default"]
    property var state: "default"

    function nextState() {
        state = states[(states.indexOf(state) + 1) % states.length];
        setPreset.running = true;
    }

    Process {
        id: setPreset
        command: ["sunsetr", "preset", root.state]
    }
}
