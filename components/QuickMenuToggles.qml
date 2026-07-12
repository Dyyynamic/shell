import QtQuick.Layouts
import "../utils"

ColumnLayout {
    id: root

    // Temporary
    property bool nightLightEnabled: false

    spacing: 10

    RowLayout {
        spacing: 10

        ToggleButton {
            Layout.fillWidth: true
            iconText: Network.icon
            iconSize: 24
            title: "Network"
            subtitle: Network.name
            checked: Network.enabled
            onClicked: Network.toggle()
        }
        ToggleButton {
            Layout.fillWidth: true
            iconText: "󰂯"
            iconSize: 24
            title: "Bluetooth"
            subtitle: Bluetooth.deviceName
            checked: Bluetooth.enabled
            onClicked: Bluetooth.toggle()
        }
    }

    RowLayout {
        spacing: 10

        ToggleButton {
            Layout.fillWidth: true
            iconText: ""
            iconSize: 24
            title: "Night Light"
            subtitle: root.nightLightEnabled ? "Active" : "Auto"
            checked: root.nightLightEnabled
            onClicked: root.nightLightEnabled = !root.nightLightEnabled
        }
        ToggleButton {
            Layout.fillWidth: true
            iconText: NotificationStore.doNotDisturb ? "󰂛" : "󰂚"
            iconSize: 24
            title: "Do Not Disturb"
            subtitle: NotificationStore.doNotDisturb ? "On" : "Off"
            checked: NotificationStore.doNotDisturb
            onClicked: NotificationStore.toggleDoNotDisturb()
        }
    }
}
