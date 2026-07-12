import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import "../utils"

Item {
    id: root

    implicitWidth: parent.width
    implicitHeight: 128

    ClippingRectangle {
        anchors.fill: parent
        color: Qt.lighter(Colors.md3.background, 2)
        radius: 12

        Image {
            anchors.fill: parent
            source: PlayerStore.lastPlayedPlayer.trackArtUrl
            fillMode: Image.PreserveAspectCrop
            visible: !!PlayerStore.lastPlayedPlayer.trackArtUrl
        }

        Rectangle {
            anchors.fill: parent
            color: Qt.lighter(Colors.md3.background, 2)
            opacity: !!PlayerStore.lastPlayedPlayer.trackArtUrl ? 0.75 : 1
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
                        color: Colors.md3.background

                        visible: !PlayerStore.lastPlayedPlayer.trackArtUrl

                        Icon {
                            anchors.centerIn: parent
                            icon: ""
                            size: 32
                            color: Colors.md3.on_background
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    spacing: 0

                    Text {
                        font.family: "NotoSans Nerd Font Propo"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        text: PlayerStore.lastPlayedPlayer.trackTitle
                        color: Colors.md3.on_background
                    }

                    Text {
                        font.family: "NotoSans Nerd Font Propo"
                        font.pixelSize: 12
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        text: PlayerStore.lastPlayedPlayer.trackArtist
                        color: Colors.md3.on_background
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
                            font.family: "NotoSans Nerd Font Propo"
                            color: Colors.md3.on_background
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
                                onClicked: PlayerStore.lastPlayedPlayer.togglePlaying()
                            }
                            IconButton {
                                size: 32
                                iconSize: 32
                                iconText: "󰒭"
                                onClicked: PlayerStore.lastPlayedPlayer.next()
                            }
                        }

                        Text {
                            font.family: "NotoSans Nerd Font Propo"
                            color: Colors.md3.on_background
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
