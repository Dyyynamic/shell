import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Networking
import "../../utils"
import "../../components" as Components

SubMenu {
    title: "Wi-Fi"
    placeholder: Wifi.enabled ? "No saved networks found" : "Wi-Fi disabled"
    model: Wifi.networks
    footerText: "Wi-Fi Settings"
    listRightMargin: 0

    hasSwitch: true
    switchChecked: Wifi.enabled
    onSwitchToggled: Wifi.toggle()

    onSettingsRequested: wifiSettings.startDetached()

    delegate: Item {
        id: networkDelegate

        required property var modelData

        width: parent.width
        height: networkContent.implicitHeight

        RowLayout {
            id: networkContent
            width: parent.width
            spacing: Theme.spacingMedium

            Components.Icon {
                icon: Wifi.icon(networkDelegate.modelData)
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                Text {
                    Layout.fillWidth: true
                    text: networkDelegate.modelData.name
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeMedium
                    font.weight: Font.DemiBold
                    color: Colors.md3.on_surface
                    elide: Text.ElideRight
                }

                Text {
                    property bool isConnecting: networkDelegate.modelData.state === ConnectionState.Connecting

                    visible: networkDelegate.modelData.connected || isConnecting
                    Layout.fillWidth: true
                    text: isConnecting ? "Connecting..." : "Connected"
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                    font.weight: Font.Normal
                    color: Colors.md3.on_surface_variant
                }
            }

            Components.Button {
                text: networkDelegate.modelData.connected ? "Disconnect" : "Connect"
                textColor: Colors.md3.on_surface_variant
                fontWeight: Font.Normal
                fontSize: Theme.fontSizeMedium

                backgroundColor: Colors.md3.surface_container_low
                backgroundOpacity: hovered ? 1 : 0

                onClicked: {
                    if (networkDelegate.modelData.connected)
                        networkDelegate.modelData.disconnect();
                    else
                        networkDelegate.modelData.connect();
                }
            }
        }
    }

    Process {
        id: wifiSettings
        command: ["better-control", "--wifi"]
    }
}
