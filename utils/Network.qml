pragma Singleton

import Quickshell
import Quickshell.Networking
import QtQuick

Singleton {
    id: root

    readonly property WifiDevice wifiDevice: {
        return Networking.devices.values.find(device => {
            return device.type === DeviceType.Wifi;
        }) ?? null;
    }

    readonly property WifiNetwork network: {
        return wifiDevice?.networks.values.find(network => {
            return network.connected;
        }) ?? null;
    }

    readonly property bool enabled: Networking.wifiEnabled
    readonly property string name: network?.name ?? ""

    readonly property string icon: {
        if (!Networking.wifiEnabled || !network)
            return "󰤮";
        if (network.signalStrength > 0.8)
            return "󰤨";
        if (network.signalStrength > 0.6)
            return "󰤥";
        if (network.signalStrength > 0.4)
            return "󰤢";
        if (network.signalStrength > 0.2)
            return "󰤟";
        return "󰤯";
    }

    function toggle() {
        Networking.wifiEnabled = !Networking.wifiEnabled;
    }
}
