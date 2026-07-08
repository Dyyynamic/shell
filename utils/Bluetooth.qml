pragma Singleton

import Quickshell
import Quickshell.Bluetooth

Scope {
    id: bluetooth

    property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    property bool enabled: adapter.enabled
    property string deviceName: adapter.devices.values.find(device => device.connected)?.name ?? ""

    function toggle() {
        adapter.enabled = !adapter.enabled;
        console.log(Bluetooth.defaultAdapter.devices);
    }
}
