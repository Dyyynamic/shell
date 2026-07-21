import QtQuick
import QtQuick.Layouts
import "../../utils"
import "../../components" as Components

Item {
    id: root

    implicitHeight: content.implicitHeight

    signal volumeMenuRequested
    signal wifiMenuRequested
    signal bluetoothMenuRequested

    ColumnLayout {
        id: content

        width: parent.width
        spacing: Theme.spacingSmall

        RowLayout {
            spacing: Theme.spacingSmall

            Components.Slider {
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

            Components.IconButton {
                iconText: ""
                size: 32

                onClicked: root.volumeMenuRequested()
            }
        }

        Components.Slider {
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

            Components.ToggleButton {
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
            Components.ToggleButton {
                Layout.fillWidth: true
                iconText: "󰂯"
                iconSize: 24
                title: "Bluetooth"
                subtitle: {
                    if (Bluetooth.connectedDevices.length > 1)
                        return `${Bluetooth.connectedDevices.length} devices`;
                    if (Bluetooth.connectedDevices.length === 1)
                        return Bluetooth.connectedDevices[0].name;
                    return "";
                }
                checked: Bluetooth.adapter?.enabled ?? false
                onToggled: Bluetooth.toggle()

                navButtonVisible: true
                onNavButtonClicked: root.bluetoothMenuRequested()
            }
        }

        RowLayout {
            spacing: Theme.spacingSmall

            Components.ToggleButton {
                Layout.fillWidth: true
                iconText: ""
                iconSize: 24
                title: "Night Light"
                subtitle: {
                    if (NightLight.state === "night")
                        return "On";
                    if (NightLight.state === "day")
                        return "Off";
                    return "Auto";
                }
                checked: NightLight.state === "default" || NightLight.state === "night"
                onToggled: NightLight.nextState()
            }
            Components.ToggleButton {
                Layout.fillWidth: true
                iconText: Notifications.doNotDisturb ? "󰂛" : "󰂚"
                iconSize: 24
                title: "Do Not Disturb"
                subtitle: Notifications.doNotDisturb ? "On" : "Off"
                checked: Notifications.doNotDisturb
                onToggled: Notifications.toggleDoNotDisturb()
            }
        }
    }
}
