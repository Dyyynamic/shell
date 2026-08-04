import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../utils"
import "../../components" as Components

SubMenu {
    title: "Wi-Fi"
    placeholder: "No saved networks found"
    model: Wifi.networks
    footerText: "Wi-Fi Settings"

    onSettingsRequested: wifiSettings.startDetached()

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

                Components.Icon {
                    icon: Wifi.icon(networkDelegate.modelData)
                }

                Text {
                    Layout.fillWidth: true
                    text: networkDelegate.modelData.name
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeMedium
                    font.weight: Font.DemiBold
                    color: Colors.md3.on_surface
                    elide: Text.ElideRight
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
    }

    Process {
        id: wifiSettings
        command: ["better-control", "--wifi"]
    }
}
