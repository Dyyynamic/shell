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
                spacing: Theme.spacingSmall

                Text {
                    Layout.fillWidth: true
                    text: volumeDelegate.modelData.properties["application.name"]
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    font.weight: Font.Medium
                    color: Theme.text
                    elide: Text.ElideRight
                }

                RowLayout {
                    spacing: Theme.spacingMedium

                    Components.Slider {
                        handleHeight: 16
                        from: 0
                        to: 1
                        value: volumeDelegate.modelData.audio.volume
                        onValueChanged: {
                            volumeDelegate.modelData.audio.volume = value;
                        }
                    }
                }
            }
        }
    }

    Process {
        id: volumeSettings
        command: ["better-control", "--volume"]
    }
}
