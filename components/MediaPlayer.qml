import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import "../utils"
import "." as Components

Item {
    id: root

    property alias pressed: mouseArea.pressed
    property alias hovered: mouseArea.containsMouse

    implicitWidth: parent.width
    implicitHeight: 128

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: Players.lastPlayedPlayer.canRaise
        hoverEnabled: true
        onClicked: Players.lastPlayedPlayer.raise()
    }

    ClippingRectangle {
        anchors.fill: parent
        radius: Theme.radiusSmall
        color: "transparent"

        Image {
            anchors.fill: parent
            source: Players.lastPlayedPlayer.trackArtUrl
            fillMode: Image.PreserveAspectCrop
            visible: !!Players.lastPlayedPlayer.trackArtUrl
        }

        Rectangle {
            anchors.fill: parent
            color: {
                if (root.pressed)
                    return Theme.colorMix(Theme.overlay, Theme.text, Theme.pressIntensity);
                if (root.hovered)
                    return Theme.colorMix(Theme.overlay, Theme.text, Theme.hoverIntensity);
                return Theme.overlay;
            }
            opacity: !!Players.lastPlayedPlayer.trackArtUrl ? 0.75 : 1

            Behavior on color {
                ColorAnimation {
                    duration: Theme.durationFast
                    easing.type: Theme.easingStandard
                }
            }
        }

        WrapperItem {
            anchors.fill: parent
            margin: Theme.spacingMedium

            RowLayout {
                spacing: Theme.spacingMedium

                ClippingRectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: height

                    radius: Theme.radiusTiny
                    color: "transparent"

                    Image {
                        id: cover
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        source: Players.lastPlayedPlayer.trackArtUrl
                        visible: !!Players.lastPlayedPlayer.trackArtUrl
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: Theme.surface

                        visible: !Players.lastPlayedPlayer.trackArtUrl

                        Components.Icon {
                            anchors.centerIn: parent
                            icon: ""
                            size: 32
                            color: Theme.textVariant
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    spacing: Theme.spacingSmall

                    ColumnLayout {
                        spacing: 0

                        Text {
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            font.weight: Font.DemiBold
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                            text: Players.lastPlayedPlayer.trackTitle
                            color: Theme.text
                        }

                        Text {
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeTiny
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                            text: Players.lastPlayedPlayer.trackArtist
                            color: Theme.textVariant
                        }
                    }

                    Components.Slider {
                        id: progress

                        to: Players.lastPlayedPlayer.length
                        value: pressed ? value : Players.lastPlayedPlayer.position

                        onPressedChanged: {
                            if (!pressed && Players.lastPlayedPlayer) {
                                Players.lastPlayedPlayer.position = value;
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 24

                        Text {
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeTiny
                            color: Theme.textVariant
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: Formatters.formatTime(Players.lastPlayedPlayer.position)
                        }

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: Theme.spacingSmall

                            Components.IconButton {
                                size: 32
                                iconSize: 32
                                iconText: "󰒮"

                                // Keep color static
                                backgroundColor: Theme.text
                                hoveredColor: Theme.text
                                pressedColor: Theme.text

                                backgroundOpacity: {
                                    if (pressed)
                                        return 0.2;
                                    if (hovered)
                                        return 0.1;
                                    return 0;
                                }

                                onClicked: Players.lastPlayedPlayer.previous()
                            }
                            Components.IconButton {
                                size: 32
                                iconSize: 32
                                iconText: {
                                    if (Players.lastPlayedPlayer.playbackState === MprisPlaybackState.Playing)
                                        return "󰏤";
                                    return "󰐊";
                                }

                                // Keep color static
                                backgroundColor: Theme.text
                                hoveredColor: Theme.text
                                pressedColor: Theme.text

                                backgroundOpacity: {
                                    if (pressed)
                                        return 0.2;
                                    if (hovered)
                                        return 0.1;
                                    return 0;
                                }

                                onClicked: Players.lastPlayedPlayer.togglePlaying()
                            }
                            Components.IconButton {
                                size: 32
                                iconSize: 32
                                iconText: "󰒭"

                                // Keep color static
                                backgroundColor: Theme.text
                                hoveredColor: Theme.text
                                pressedColor: Theme.text

                                backgroundOpacity: {
                                    if (pressed)
                                        return 0.2;
                                    if (hovered)
                                        return 0.1;
                                    return 0;
                                }

                                onClicked: Players.lastPlayedPlayer.next()
                            }
                        }

                        Text {
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeTiny
                            color: Theme.textVariant
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            text: Formatters.formatTime(Players.lastPlayedPlayer.length)
                        }
                    }
                }
            }
        }
    }

    Timer {
        running: Players.lastPlayedPlayer.playbackState == MprisPlaybackState.Playing

        interval: 1000
        repeat: true

        onTriggered: Players.lastPlayedPlayer.positionChanged()
    }
}
