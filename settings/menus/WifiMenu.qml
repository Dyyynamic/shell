pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Networking
import "../../utils"
import "../../components" as Components
import "." as Menus

Item {
    id: root

    anchors.fill: parent

    StackView.onActivated: {
        if (Wifi.enabled && Wifi.wifiDevice)
            Wifi.wifiDevice.scannerEnabled = true;
    }

    StackView.onDeactivated: {
        if (Wifi.wifiDevice)
            Wifi.wifiDevice.scannerEnabled = false;
    }

    ScrollView {
        anchors.fill: parent
        clip: true

        WrapperItem {
            width: root.width
            margin: Theme.spacingExtraLarge

            ColumnLayout {
                spacing: Theme.spacingExtraLarge

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Theme.spacingMedium

                        Text {
                            Layout.fillWidth: true
                            text: "Wi-Fi"
                            color: Colors.md3.on_surface
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeExtraLarge
                            font.weight: Font.Bold
                        }

                        Components.Switch {
                            checked: Wifi.enabled
                            onCheckedChanged: Wifi.toggle()
                        }
                    }

                    Text {
                        text: "Manage Wi-Fi networks"
                        color: Colors.md3.on_surface_variant
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeLarge
                        font.weight: Font.DemiBold
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLarge

                    Text {
                        text: "Saved Networks"
                        color: Colors.md3.on_surface
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeMedium
                        font.weight: Font.DemiBold
                    }

                    NetworkList {
                        model: ScriptModel {
                            values: [...Wifi.knownNetworks].sort((a, b) => {
                                if (a.connected !== b.connected) {
                                    return b.connected - a.connected;
                                }
                                return b.signalStrength - a.signalStrength;
                            })
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLarge

                    Text {
                        text: "Available Networks"
                        color: Colors.md3.on_surface
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeMedium
                        font.weight: Font.DemiBold
                    }

                    NetworkList {
                        model: ScriptModel {
                            values: [...Wifi.availableNetworks].sort((a, b) => {
                                return b.signalStrength - a.signalStrength;
                            })
                        }
                    }
                }
            }
        }
    }

    Menus.PasswordDialog {
        id: passwordDialog
    }

    component NetworkList: ListView {
        Layout.fillWidth: true
        Layout.preferredHeight: contentHeight
        interactive: false

        delegate: Button {
            id: delegate

            required property var modelData
            property var network: modelData

            width: parent?.width
            height: 60

            background: Rectangle {
                anchors.fill: parent
                radius: Theme.radiusSmall
                color: {
                    if (delegate.pressed)
                        return Theme.colorMix(Colors.md3.surface_container_low, Colors.md3.on_surface, Theme.pressIntensity);
                    if (delegate.hovered)
                        return Theme.colorMix(Colors.md3.surface_container_low, Colors.md3.on_surface, Theme.hoverIntensity);
                    return Colors.md3.surface_container_low;
                }
            }

            onClicked: {
                if (network.known) {
                    network.connect();
                } else {
                    passwordDialog.network = network;
                    passwordDialog.open();
                }
            }

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                radius: Theme.radiusSmall
            }

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.height

                    Components.Icon {
                        anchors.centerIn: parent
                        icon: delegate.network ? Wifi.icon(delegate.network) : ""
                    }
                }

                ColumnLayout {
                    spacing: 0
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true

                        text: delegate.network?.name ?? ""
                        color: Colors.md3.on_surface
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeMedium
                        font.weight: Font.DemiBold
                    }

                    Text {
                        Layout.fillWidth: true

                        visible: delegate.network.security !== WifiSecurityType.Open

                        text: {
                            if (!delegate.network)
                                return "";
                            if (delegate.network.state === ConnectionState.Connecting)
                                return "Connecting...";
                            if (delegate.network.state === ConnectionState.Connected)
                                return "Connected";
                            if (delegate.network.security !== WifiSecurityType.Open)
                                return "Secured";
                            return "";
                        }

                        color: Colors.md3.on_surface_variant
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                    }
                }

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.height

                    Components.Icon {
                        anchors.centerIn: parent

                        icon: {
                            if (!delegate.network)
                                return "";
                            if (delegate.network.connected)
                                return "";
                            if (delegate.network.security !== WifiSecurityType.Open)
                                return "";
                            return "";
                        }
                    }
                }
            }
        }
    }
}
