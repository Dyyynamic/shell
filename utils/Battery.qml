pragma Singleton

import Quickshell
import Quickshell.Services.UPower

Scope {
    property UPowerDevice battery: UPower.devices.values.find(device => {
        return device.isLaptopBattery;
    })

    property bool available: !!battery
    property real value: battery ? battery.percentage : 0
    property UPowerDeviceState state: battery ? battery.state : UPowerDeviceState.Empty

    property string description: {
        const percentage = `${Math.round(value * 100)}`;

        if (state === UPowerDeviceState.Charging)
            return `${percentage}% Charging`;

        if (state === UPowerDeviceState.FullyCharged)
            return `${percentage}% Full`;

        return `${percentage}%`;
    }

    property string icon: {
        if (state === UPowerDeviceState.Charging || state === UPowerDeviceState.FullyCharged)
            return "";
        if (value > 0.8)
            return "";
        if (value > 0.6)
            return "";
        if (value > 0.4)
            return "";
        if (value > 0.2)
            return "";
        return "";
    }
}
