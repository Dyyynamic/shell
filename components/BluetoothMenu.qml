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
        id: networkDelegate

        required property var modelData

        width: parent.width
        height: networkContent.implicitHeight

        ColumnLayout {
            id: networkContent

            width: parent.width

            spacing: Theme.spacingSmall

            RowLayout {
                spacing: Theme.spacingMedium

                Icon {
                    icon: "󰂯"
                }

                Text {
                    Layout.fillWidth: true
                    text: networkDelegate.modelData.name
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    color: Theme.text
                    elide: Text.ElideRight
                }

                Item {
                    Layout.fillWidth: true
                }

                RegularButton {
                    text: networkDelegate.modelData.connected ? "Disconnect" : "Connect"
                    textColor: Theme.textSecondary
                    color: Theme.surface
                    onClicked: {
                        if (networkDelegate.modelData.connected)
                            networkDelegate.modelData.disconnect()
                        else
                            networkDelegate.modelData.connect()
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
