import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Mpris
import "../utils"

Item {
    id: player

    implicitWidth: parent.width
    implicitHeight: 128

    function formatTime(seconds) {
        seconds = Math.floor(seconds);

        const hours = Math.floor(seconds / 3600);
        const minutes = Math.floor((seconds % 3600) / 60);
        const remainingSeconds = seconds % 60;

        if (hours > 0) {
            return `${hours}:${minutes.toString().padStart(2, "0")}:${remainingSeconds.toString().padStart(2, "0")}`;
        }

        return `${minutes}:${remainingSeconds.toString().padStart(2, "0")}`;
    }

    ClippingRectangle {
        anchors.fill: parent
        color: Qt.lighter(Colors.md3.background, 2)
        radius: 12

        Image {
            anchors.fill: parent
            source: PlayerStore.lastPlayedPlayer.trackArtUrl
            fillMode: Image.PreserveAspectCrop
        }

        Rectangle {
            anchors.fill: parent
            color: Qt.lighter(Colors.md3.background, 2)
            opacity: 0.75
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
                    }
                }

                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    spacing: 0

                    Text {
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        text: PlayerStore.lastPlayedPlayer.trackTitle
                        color: Colors.md3.on_background
                    }

                    Text {
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
                            color: Colors.md3.on_background
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: player.formatTime(PlayerStore.lastPlayedPlayer.position)
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
                            color: Colors.md3.on_background
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            text: player.formatTime(PlayerStore.lastPlayedPlayer.length)
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
