import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../utils"

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

        ColumnLayout {
            id: volumeContent

            width: parent.width

            spacing: Theme.spacingSmall

            RowLayout {
                spacing: Theme.spacingMedium

                Icon {
                    icon: ""
                }

                Text {
                    Layout.fillWidth: true
                    text: volumeDelegate.modelData.properties["application.name"]
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    color: Theme.text
                    elide: Text.ElideRight
                }
            }

            CustomSlider {
                handleHeight: 16
                from: 0
                to: 1
                value: volumeDelegate.modelData.audio.volume
                onValueChanged: {
                    volumeDelegate.modelData.audio.volume = value
                }
            }
        }
    }

    Process {
        id: volumeSettings
        command: ["better-control", "--volume"]
    }
}
