pragma Singleton

import Quickshell
import Quickshell.Bluetooth

Scope {
    id: bluetooth

    property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    property bool enabled: adapter.enabled

    function toggle() {
        adapter.enabled = !adapter.enabled;
    }
}
