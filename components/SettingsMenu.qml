import QtQuick
import QtQuick.Layouts
import "../utils"

Item {
    id: root

    implicitHeight: content.implicitHeight

    // Temporary
    property bool nightLightEnabled: false

    signal volumeMenuRequested
    signal wifiMenuRequested
    signal bluetoothMenuRequested

    ColumnLayout {
        id: content

        width: parent.width
        spacing: Theme.spacingSmall

        RowLayout {
            spacing: Theme.spacingSmall

            CustomSlider {
                trackHeight: 32
                trackRadius: Theme.radiusTiny
                handleHeight: 38

                icon: Audio.icon(Audio.defaultSink)
                Layout.fillWidth: true

                from: 0
                to: 1
                value: Audio.defaultSink?.audio.volume ?? 0
                onMoved: Audio.defaultSink.audio.volume = value
            }

            IconButton {
                iconText: ""
                size: 32

                onClicked: root.volumeMenuRequested()
            }
        }

        CustomSlider {
            trackHeight: 32
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
                iconText: Wifi.icon(Wifi.connectedNetwork)
                iconSize: 24
                title: "Wi-Fi"
                subtitle: Wifi.name
                checked: Wifi.enabled
                onToggled: Wifi.toggle()

                navButtonVisible: true
                onNavButtonClicked: root.wifiMenuRequested()
            }
            ToggleButton {
                Layout.fillWidth: true
                iconText: "󰂯"
                iconSize: 24
                title: "Bluetooth"
                subtitle: {
                    if (Bluetooth.connectedDevices.length > 1)
                        return `${Bluetooth.connectedDevices.length} devices`
                    if (Bluetooth.connectedDevices.length === 1)
                        return Bluetooth.connectedDevices[0].name
                    return ""
                }
                checked: Bluetooth.adapter?.enabled ?? false
                onToggled: Bluetooth.toggle()

                navButtonVisible: true
                onNavButtonClicked: root.bluetoothMenuRequested()
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
                onToggled: root.nightLightEnabled = !root.nightLightEnabled
            }
            ToggleButton {
                Layout.fillWidth: true
                iconText: NotificationStore.doNotDisturb ? "󰂛" : "󰂚"
                iconSize: 24
                title: "Do Not Disturb"
                subtitle: NotificationStore.doNotDisturb ? "On" : "Off"
                checked: NotificationStore.doNotDisturb
                onToggled: NotificationStore.toggleDoNotDisturb()
            }
        }
    }
}
