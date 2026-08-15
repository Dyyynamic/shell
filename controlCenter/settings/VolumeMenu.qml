import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../utils"
import "../../components" as Components

SubMenu {
    title: "Volume"
    placeholder: "No applications playing audio"
    model: Audio.outputStreams
    footerText: "Volume Settings"

    onSettingsRequested: volumeSettings.startDetached()

    delegate: Item {
        id: volumeDelegate

        required property var modelData

        width: parent.width
        height: volumeContent.implicitHeight

        RowLayout {
            id: volumeContent

            width: parent.width

            spacing: Theme.spacingMedium

            Components.Icon {
                icon: ""
            }

            ColumnLayout {
                spacing: Theme.spacingTiny

                ColumnLayout {
                    spacing: 0

                    Text {
                        Layout.fillWidth: true

                        text: Formatters.capitalize(volumeDelegate.modelData.name)
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeMedium
                        font.weight: Font.DemiBold
                        color: Colors.md3.on_surface
                        elide: Text.ElideRight
                    }

                    Text {
                        Layout.fillWidth: true
                        visible: !!volumeDelegate.modelData.properties["media.name"]

                        text: volumeDelegate.modelData.properties["media.name"]
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        color: Colors.md3.on_surface_variant
                        elide: Text.ElideRight
                    }
                }

                Components.Slider {
                    id: volumeSlider

                    handleHeight: 16
                    value: volumeDelegate.modelData.audio.volume
                    onValueChanged: {
                        volumeDelegate.modelData.audio.volume = value;
                    }
                }

                Components.Tooltip {
                    target: volumeSlider
                    anchor: volumeSlider.handle
                    showWhilePressed: true
                    side: "top"
                    text: `${Math.round(volumeSlider.value * 100)}%`
                }
            }
        }
    }

    Process {
        id: volumeSettings
        command: ["better-control", "--volume"]
    }
}
