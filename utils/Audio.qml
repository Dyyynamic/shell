pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property var nodes: Pipewire.nodes

    readonly property PwNode defaultSink: Pipewire.defaultAudioSink

    readonly property var outputStreams: ScriptModel {
        values: root.nodes.values.filter(node => {
            return node.type === PwNodeType.AudioOutStream;
        })
    }

    function icon(node: PwNode): string {
        if (!node)
            return "";
        if (node.audio.muted)
            return "";
        if (node.audio.volume > 0.67)
            return "";
        if (node.audio.volume > 0.33)
            return "";
        if (node.audio.volume > 0)
            return "";
        return "";
    }

    PwObjectTracker {
        objects: root.nodes.values
    }
}
