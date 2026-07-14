import QtQuick
import QtQuick.Layouts
import "../utils"

Widget {
    id: root

    // Temporary
    property bool nightLightEnabled: false

    ColumnLayout {
        spacing: Theme.spacingSmall

        CustomSlider {
            trackHeight: 30
            trackRadius: Theme.radiusTiny
            handleHeight: 38

            icon: Volume.icon
            Layout.fillWidth: true

            from: 0
            to: 1
            value: Volume.value
            onMoved: Volume.setVolume(value)
        }

        CustomSlider {
            trackHeight: 30
            trackRadius: Theme.radiusTiny
            handleHeight: 38

            visible: Brightness.backlight
            icon: ""
            Layout.fillWidth: true
            value: Brightness.value

            onMoved: {
                Brightness.setBrightness(parseInt(value));
            }
        }

        RowLayout {
            spacing: Theme.spacingSmall

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
            spacing: Theme.spacingSmall

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
}
