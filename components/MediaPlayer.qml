import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import "../utils"

Item {
    id: root

    property alias pressed: mouseArea.pressed
    property alias hovered: mouseArea.containsMouse

    implicitWidth: parent.width
    implicitHeight: 128

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: PlayerStore.lastPlayedPlayer.canRaise
        hoverEnabled: true
        onClicked: PlayerStore.lastPlayedPlayer.raise()
    }

    ClippingRectangle {
        anchors.fill: parent
        radius: 12

        Image {
            anchors.fill: parent
            source: PlayerStore.lastPlayedPlayer.trackArtUrl
            fillMode: Image.PreserveAspectCrop
            visible: !!PlayerStore.lastPlayedPlayer.trackArtUrl
        }

        Rectangle {
            anchors.fill: parent
            color: {
                if (root.pressed)
                    return Qt.lighter(Theme.overlay, Theme.pressedMultiplier);
                if (root.hovered)
                    return Qt.lighter(Theme.overlay, Theme.hoverMultiplier);
                return Theme.overlay;
            }
            opacity: !!PlayerStore.lastPlayedPlayer.trackArtUrl ? 0.75 : 1

            Behavior on color {
                ColorAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }

        WrapperItem {
            anchors.fill: parent
            margin: 10

            RowLayout {
                spacing: 10

                ClippingRectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: height

                    radius: 10

                    Image {
                        id: cover
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        source: PlayerStore.lastPlayedPlayer.trackArtUrl
                        visible: !!PlayerStore.lastPlayedPlayer.trackArtUrl
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: Theme.base

                        visible: !PlayerStore.lastPlayedPlayer.trackArtUrl

                        Icon {
                            anchors.centerIn: parent
                            icon: ""
                            size: 32
                            color: Theme.text
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    spacing: 0

                    Text {
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        font.weight: Font.DemiBold
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        text: PlayerStore.lastPlayedPlayer.trackTitle
                        color: Theme.text
                    }

                    Text {
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeTiny
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        text: PlayerStore.lastPlayedPlayer.trackArtist
                        color: Theme.text
                    }

                    CustomSlider {
                        id: progress

                        to: PlayerStore.lastPlayedPlayer.length
                        value: pressed ? value : PlayerStore.lastPlayedPlayer.position

                        onPressedChanged: {
                            if (!pressed && PlayerStore.lastPlayedPlayer) {
                                PlayerStore.lastPlayedPlayer.position = value;
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 24

                        Text {
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeTiny
                            color: Theme.text
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: Formatters.formatTime(PlayerStore.lastPlayedPlayer.position)
                        }

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 8

                            IconButton {
                                size: 32
                                iconSize: 32
                                iconText: "󰒮"

                                color: {
                                    if (pressed)
                                        return "#40ffffff";
                                    if (hovered)
                                        return "#20ffffff";
                                    return "transparent";
                                }

                                onClicked: PlayerStore.lastPlayedPlayer.previous()
                            }
                            IconButton {
                                size: 32
                                iconSize: 32
                                iconText: {
                                    if (PlayerStore.lastPlayedPlayer.playbackState === MprisPlaybackState.Playing)
                                        return "󰏤";
                                    return "󰐊";
                                }

                                color: {
                                    if (pressed)
                                        return "#40ffffff";
                                    if (hovered)
                                        return "#20ffffff";
                                    return "transparent";
                                }

                                onClicked: PlayerStore.lastPlayedPlayer.togglePlaying()
                            }
                            IconButton {
                                size: 32
                                iconSize: 32
                                iconText: "󰒭"

                                color: {
                                    if (pressed)
                                        return "#40ffffff";
                                    if (hovered)
                                        return "#20ffffff";
                                    return "transparent";
                                }

                                onClicked: PlayerStore.lastPlayedPlayer.next()
                            }
                        }

                        Text {
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeTiny
                            color: Theme.text
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            text: Formatters.formatTime(PlayerStore.lastPlayedPlayer.length)
                        }
                    }
                }
            }
        }
    }

    Timer {
        running: PlayerStore.lastPlayedPlayer.playbackState == MprisPlaybackState.Playing

        interval: 1000
        repeat: true

        onTriggered: PlayerStore.lastPlayedPlayer.positionChanged()
    }
}
