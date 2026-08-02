import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../utils"
import "../../components" as Components
import "../../capture" as Capture
import ".." as ControlCenter

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
                Brightness.setBrightness(value);
            }
        }

        ColumnLayout {
            spacing: Theme.spacingSmall

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingSmall

                Components.PanelButton {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 2
                    icon: Wifi.icon(Wifi.connectedNetwork)
                    title: "Wi-Fi"
                    subtitle: Wifi.enabled ? (Wifi.name ? Wifi.name : "On") : "Off"
                    checked: Wifi.enabled
                    checkableIcon: true
                    onToggled: Wifi.toggle()
                    onClicked: root.wifiMenuRequested()
                }

                Components.PanelButton {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 2
                    icon: "󰂯"
                    title: "Bluetooth"
                    subtitle: {
                        if (Bluetooth.adapter?.enabled) {
                            if (Bluetooth.connectedDevices.length > 1)
                                return `${Bluetooth.connectedDevices.length} devices`;
                            if (Bluetooth.connectedDevices.length === 1)
                                return Bluetooth.connectedDevices[0].name;
                            return "On";
                        }
                        return "Off";
                    }
                    checked: Bluetooth.adapter?.enabled ?? false
                    checkableIcon: true
                    onToggled: Bluetooth.toggle()
                    onClicked: root.bluetoothMenuRequested()
                }

                Components.PanelButton {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    icon: ""
                    iconOnly: true
                    onClicked: {
                        ControlCenter.Controller.closeWithAction(() => {
                            Theme.toggleDarkMode();
                        });
                    }
                    checked: Theme.mode === "dark"
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingSmall

                Components.PanelButton {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 2
                    icon: ""
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

                Components.PanelButton {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    icon: ""
                    iconOnly: true
                    onClicked: {
                        ControlCenter.Controller.closeWithAction(() => {
                            Capture.Controller.request(Capture.Controller.CaptureType.Screenshot, Capture.Controller.CaptureMode.Region);
                        });
                    }
                }

                Components.PanelButton {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    icon: "󰻃"
                    iconOnly: true
                    onClicked: {
                        ControlCenter.Controller.closeWithAction(() => {
                            Capture.Controller.request(Capture.Controller.CaptureType.Record, Capture.Controller.CaptureMode.Region);
                        });
                    }
                }

                Components.PanelButton {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    icon: "󰈊"
                    iconOnly: true
                    onClicked: {
                        ControlCenter.Controller.closeWithAction(() => {
                            ControlCenter.Controller.startColorPicker();
                        });
                    }
                }
            }
        }
    }
}
