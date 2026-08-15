import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Bluetooth
import "../../utils" as Utils
import "../../components" as Components

SubMenu {
    title: "Bluetooth"
    placeholder: Utils.Bluetooth.adapter?.enabled ? "No saved devices found" : "Bluetooth disabled"
    model: Utils.Bluetooth.devices
    footerText: "Bluetooth Settings"
    listRightMargin: 0

    hasSwitch: true
    switchChecked: Utils.Bluetooth.adapter?.enabled
    onSwitchToggled: Utils.Bluetooth.toggle()

    onSettingsRequested: bluetoothSettings.startDetached()

    delegate: Item {
        id: bluetoothDelegate

        required property var modelData

        width: parent.width
        height: bluetoothContent.implicitHeight

        RowLayout {
            id: bluetoothContent
            width: parent.width
            spacing: Utils.Theme.spacingMedium

            Components.Icon {
                icon: "󰂯"
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                Text {
                    Layout.fillWidth: true
                    text: bluetoothDelegate.modelData.name
                    font.family: Utils.Theme.fontFamily
                    font.pixelSize: Utils.Theme.fontSizeMedium
                    font.weight: Font.DemiBold
                    color: Utils.Colors.md3.on_surface
                    elide: Text.ElideRight
                }

                Text {
                    property bool isConnecting: bluetoothDelegate.modelData.state === BluetoothDeviceState.Connecting

                    visible: modelData.connected || isConnecting
                    Layout.fillWidth: true
                    text: isConnecting ? "Connecting..." : "Connected"
                    font.family: Utils.Theme.fontFamily
                    font.pixelSize: Utils.Theme.fontSizeSmall
                    font.weight: Font.Normal
                    color: Utils.Colors.md3.on_surface_variant
                }
            }

            Components.Button {
                text: bluetoothDelegate.modelData.connected ? "Disconnect" : "Connect"
                textColor: Utils.Colors.md3.on_surface_variant
                fontWeight: Font.Normal
                fontSize: Utils.Theme.fontSizeMedium

                backgroundColor: Utils.Colors.md3.surface_container_low
                backgroundOpacity: hovered ? 1 : 0

                onClicked: {
                    if (bluetoothDelegate.modelData.connected)
                        bluetoothDelegate.modelData.disconnect();
                    else
                        bluetoothDelegate.modelData.connect();
                }
            }
        }
    }

    Process {
        id: bluetoothSettings
        command: ["better-control", "--bluetooth"]
    }
}
