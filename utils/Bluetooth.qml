pragma Singleton

import Quickshell
import Quickshell.Bluetooth

Singleton {
    id: root

    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property bool enabled: adapter?.enabled ?? false
    readonly property string deviceName: {
        return adapter?.devices.values.find(device => {
            return device.connected;
        })?.name ?? "";
    }

    function toggle() {
        adapter.enabled = !adapter.enabled;
    }
}
