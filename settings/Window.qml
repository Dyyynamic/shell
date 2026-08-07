import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../components" as Components
import "../utils"
import "./menus" as Menus

FloatingWindow {
    id: root

    title: "Settings"
    minimumSize: Qt.size(600, 450)

    color: Colors.md3.background

    property string section: "Account"

    property var wifiMenu: Menus.WifiMenu {}

    RowLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacingMedium
        spacing: Theme.spacingMedium

        ColumnLayout {
            Layout.preferredWidth: 180
            Layout.maximumWidth: 180
            Layout.fillHeight: true

            spacing: 0

            Item {
                Layout.preferredHeight: 48
                Layout.fillWidth: true

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    leftPadding: Theme.spacingMedium
                    rightPadding: Theme.spacingMedium

                    text: "Settings"
                    color: Colors.md3.on_surface
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeMedium
                    font.weight: Font.DemiBold
                }
            }

            ClippingRectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"

                ListView {
                    anchors.fill: parent

                    model: ListModel {
                        ListElement {
                            name: "Account"
                            sectionIcon: ""
                        }
                        ListElement {
                            name: "Wi-Fi"
                            sectionIcon: "󰤨"
                        }
                        ListElement {
                            name: "Bluetooth"
                            sectionIcon: "󰂯"
                        }
                        ListElement {
                            name: "Audio"
                            sectionIcon: ""
                        }
                        ListElement {
                            name: "Style"
                            sectionIcon: ""
                        }
                    }

                    delegate: Components.Button {
                        text: name
                        iconGlyph: sectionIcon
                        radius: Theme.radiusSmall
                        height: 48
                        width: parent.width
                        textAlignment: Text.AlignLeft
                        iconSpacing: Theme.spacingMedium
                        fontSize: Theme.fontSizeMedium

                        textColor: {
                            if (root.section === name) {
                                return Colors.md3.on_secondary_container
                            }
                            return Colors.md3.on_surface
                        }
                        iconColor: {
                            if (root.section === name) {
                                return Colors.md3.on_secondary_container
                            }
                            return Colors.md3.on_surface
                        }

                        backgroundColor: {
                            if (root.section === name) {
                                return Colors.md3.secondary_container
                            }
                            return Colors.md3.background
                        }

                        onClicked: {
                            root.section = name
                        }
                    }
                }
            }

            Components.Button {
                text: "About"
                iconGlyph: ""
                radius: Theme.radiusSmall
                Layout.preferredHeight: 48
                Layout.fillWidth: true
                textAlignment: Text.AlignLeft
                iconSpacing: Theme.spacingMedium

                textColor: Colors.md3.on_surface
                fontSize: Theme.fontSizeMedium
                iconColor: Colors.md3.on_surface_variant
                backgroundColor: Colors.md3.background
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Rectangle {
                anchors.fill: parent
                color: Colors.md3.surface_container_low
                radius: Theme.radiusMedium
            }

            StackView {
                id: stackView
                anchors.fill: parent
                // anchors.margins: Theme.spacingExtraLarge

                initialItem: root.wifiMenu
            }
        }
    }
}
