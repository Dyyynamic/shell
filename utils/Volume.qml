pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Scope {
    id: volume

    property PwNode sink: Pipewire.defaultAudioSink

    property bool available: !!sink
    property bool muted: sink.audio.muted ?? false
    property real value: sink.audio.volume ?? 0

    property string icon: {
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
        objects: [volume.sink]
    }
}
