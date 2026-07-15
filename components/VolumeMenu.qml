import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Widgets
import "../utils"

Item {
    id: root

    implicitHeight: content.implicitHeight

    // Temporary
    property bool nightLightEnabled: false

    signal backRequested
    signal closeRequested

    ColumnLayout {
        id: content

        width: parent.width
        spacing: Theme.spacingMedium

        WrapperItem {
            margin: Theme.spacingSmall

            RowLayout {
                spacing: Theme.spacingMedium

                IconButton {
                    iconText: ""
                    onClicked: root.backRequested()
                    size: 32
                    iconSize: 20
                }

                Text {
                    text: "Volume"
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    font.bold: true
                    color: Theme.text
                }
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.leftMargin: Theme.spacingSmall
            Layout.rightMargin: Theme.spacingSmall

            implicitHeight: Math.min(contentHeight, 200)
            interactive: contentHeight > height

            spacing: Theme.spacingLarge
            clip: true

            model: Audio.streams

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
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 1
            color: Theme.overlay

            Layout.leftMargin: Theme.spacingSmall
            Layout.rightMargin: Theme.spacingSmall
        }

        Button {
            id: volumeSettingsButton

            text: "Volume Settings"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
            palette.buttonText: Theme.text

            implicitHeight: 32
            leftPadding: Theme.spacingSmall
            rightPadding: Theme.spacingSmall

            onClicked: {
                root.closeRequested();
                volumeSettings.startDetached();
            }

            background: Rectangle {
                radius: Theme.radiusTiny

                color: {
                    if (volumeSettingsButton.pressed)
                        return Qt.lighter(Theme.surface, Theme.pressMultiplier);
                    if (volumeSettingsButton.hovered)
                        return Qt.lighter(Theme.surface, Theme.hoverMultiplier);
                    return Theme.surface;
                }

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.animationDuration
                        easing.type: Theme.animationEasing
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
