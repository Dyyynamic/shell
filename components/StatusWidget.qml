import QtQuick
import Quickshell.Services.Pipewire
import "../utils"

Widget {
    id: statusWidget

    width: implicitWidth + 8

    Row {
        spacing: 8

        Icon {
            id: network
            icon: {
                if (!Network.enabled)
                    return "󰤮";
                if (Network.signal > 80)
                    return "󰤨";
                if (Network.signal > 60)
                    return "󰤥";
                if (Network.signal > 40)
                    return "󰤢";
                if (Network.signal > 20)
                    return "󰤟";
                return "󰤯";
            }
        }

        Icon {
            icon: {
                if (!Pipewire.defaultAudioSink)
                    return "";
                if (Pipewire.defaultAudioSink.audio.muted)
                    return "";
                if (Pipewire.defaultAudioSink.audio.volume > 0.67)
                    return "";
                if (Pipewire.defaultAudioSink.audio.volume > 0.33)
                    return "";
                return "";
            }

            PwObjectTracker {
                objects: [Pipewire.defaultAudioSink]
            }
        }
    }
}
