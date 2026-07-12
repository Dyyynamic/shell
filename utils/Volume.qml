pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool available: !!sink
    readonly property bool muted: sink.audio.muted ?? false
    readonly property real value: sink.audio.volume ?? 0

    readonly property string icon: {
        if (!available)
            return "";
        if (muted)
            return "";
        if (value > 0.67)
            return "";
        if (value > 0.33)
            return "";
        if (value > 0)
            return "";
        return "";
    }

    function setVolume(value) {
        if (available)
            sink.audio.volume = value;
    }

    PwObjectTracker {
        objects: [root.sink]
    }
}
