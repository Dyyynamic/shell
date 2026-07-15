import QtQuick
import QtQuick.Layouts
import "../utils"

Item {
    id: root

    implicitHeight: content.implicitHeight

    // Temporary
    property bool nightLightEnabled: false

    signal volumeMenuRequested

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
                iconText: Network.icon
                iconSize: 24
                title: "Network"
                subtitle: Network.name
                checked: Network.enabled
                onToggled: Network.toggle()
            }
            ToggleButton {
                Layout.fillWidth: true
                iconText: "󰂯"
                iconSize: 24
                title: "Bluetooth"
                subtitle: Bluetooth.deviceName
                checked: Bluetooth.enabled
                onToggled: Bluetooth.toggle()
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
