import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../utils"

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

                Icon {
                    icon: "󰂯"
                }

                Text {
                    Layout.fillWidth: true
                    text: bluetoothDelegate.modelData.name
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    color: Theme.text
                    elide: Text.ElideRight
                }

                RegularButton {
                    text: bluetoothDelegate.modelData.connected ? "Disconnect" : "Connect"
                    textColor: Theme.textSecondary
                    color: Theme.surface
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
