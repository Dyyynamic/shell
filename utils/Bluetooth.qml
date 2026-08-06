pragma Singleton

import Quickshell
import Quickshell.Bluetooth

Singleton {
    id: root

    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter

    readonly property var devices: adapter?.devices.values ?? []

    readonly property var connectedDevices: {
        return devices.filter(device => device.connected) ?? [];
    }

    function toggle() {
        adapter.enabled = !adapter.enabled;
    }
}
