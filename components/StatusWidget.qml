import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import "../utils"

Widget {
    id: root

    property var battery: UPower.devices.values.find(device => {
        return device.isLaptopBattery;
    })

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

        Icon {
            visible: !!statusWidget.battery

            icon: {
                if (root.battery.state == UPowerDeviceState.Charging || root.battery.state == UPowerDeviceState.FullyCharged)
                    return "";
                if (root.battery.percentage > 0.8)
                    return "";
                if (root.battery.percentage > 0.6)
                    return "";
                if (root.battery.percentage > 0.4)
                    return "";
                if (root.battery.percentage > 0.2)
                    return "";
                return "";
            }
        }
    }
}
