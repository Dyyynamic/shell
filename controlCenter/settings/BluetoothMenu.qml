import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../utils"
import "../../components" as Components

SubMenu {
    title: "Bluetooth"
    placeholder: "No saved devices found"
    model: Bluetooth.devices
    footerText: "Bluetooth Settings"

    onSettingsRequested: bluetoothSettings.startDetached()

    delegate: Item {
        id: bluetoothDelegate

        required property var modelData

        width: parent.width
        height: bluetoothContent.implicitHeight

        ColumnLayout {
            id: bluetoothContent

            width: parent.width

            spacing: Theme.spacingSmall

            RowLayout {
                spacing: Theme.spacingMedium

                Components.Icon {
                    icon: "󰂯"
                }

                Text {
                    Layout.fillWidth: true
                    text: bluetoothDelegate.modelData.name
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeMedium
                    font.weight: Font.DemiBold
                    color: Colors.md3.on_surface
                    elide: Text.ElideRight
                }

                Components.Button {
                    text: bluetoothDelegate.modelData.connected ? "Disconnect" : "Connect"
                    textColor: Colors.md3.on_surface_variant
                    fontWeight: Font.Normal
                    fontSize: Theme.fontSizeMedium

                    backgroundColor: Colors.md3.surface_container_low
                    backgroundOpacity: hovered ? 1 : 0

                    onClicked: {
                        if (bluetoothDelegate.modelData.connected)
                            bluetoothDelegate.modelData.disconnect()
                        else
                            bluetoothDelegate.modelData.connect()
                    }
                }
            }
        }
    }

    Process {
        id: bluetoothSettings
        command: ["better-control", "--bluetooth"]
    }
}
