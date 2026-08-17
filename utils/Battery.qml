pragma Singleton

import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property UPowerDevice battery: {
        return UPower.devices.values.find(device => {
            return device.isLaptopBattery;
        }) ?? null;
    }

    readonly property bool available: !!battery
    readonly property real percentage: battery ? battery?.percentage : 0
    readonly property bool charging: battery?.state === UPowerDeviceState.Charging
}
