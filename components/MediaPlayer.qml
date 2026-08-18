import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.Mpris
import "../utils"
import "." as Components

Item {
    id: root

    property alias pressed: mouseArea.pressed
    property alias hovered: mouseArea.containsMouse

    property var player: Players.players[0]

    // Some live streaming services (Twitch) return an absurdly long length
    // instead of setting lengthSupported to false
    property bool live: !player.lengthSupported || player.length > 365 * 24 * 60 * 60

    width: parent.width
    implicitHeight: 128

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.player.canRaise
        hoverEnabled: true
        onClicked: root.player.raise()
    }

    ClippingRectangle {
        anchors.fill: parent
        radius: Theme.radiusSmall
        color: "transparent"

        Image {
            id: trackArtBackground
            anchors.fill: parent
            source: root.player.trackArtUrl
            fillMode: Image.PreserveAspectCrop
            visible: !!root.player.trackArtUrl
        }

        MultiEffect {
            anchors.fill: parent
            source: trackArtBackground

            blurEnabled: true
            blur: 1
            blurMax: 32
            autoPaddingEnabled: false
        }

        Rectangle {
            anchors.fill: parent
            color: {
                if (root.pressed)
                    return Theme.colorMix(Colors.md3.surface_container_high, Colors.md3.on_surface, Theme.pressIntensity);
                if (root.hovered)
                    return Theme.colorMix(Colors.md3.surface_container_high, Colors.md3.on_surface, Theme.hoverIntensity);
                return Colors.md3.surface_container_high;
            }
            opacity: !!root.player.trackArtUrl ? 0.75 : 1

            Behavior on color {
                ColorAnimation {
                    duration: Theme.durationFast
                    easing.type: Theme.easingStandard
                }
            }
        }

        Item {
            anchors.fill: parent
            anchors.margins: Theme.spacingMedium

            RowLayout {
                anchors.fill: parent
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
                        source: root.player.trackArtUrl
                        visible: !!root.player.trackArtUrl
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: Colors.md3.surface_container_low

                        visible: !root.player.trackArtUrl

                        Components.Icon {
                            anchors.centerIn: parent
                            icon: ""
                            size: 32
                            color: Colors.md3.on_surface_variant
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    spacing: Theme.spacingSmall

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 40

                        ColumnLayout {
                            anchors {
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                right: parent.right
                            }
                            spacing: 0

                            Text {
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeMedium
                                font.weight: Font.DemiBold
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                text: root.player.trackTitle
                                color: Colors.md3.on_surface
                            }

                            Text {
                                visible: !!root.player.trackArtist
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeSmall
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                text: root.player.trackArtist
                                color: Colors.md3.on_surface_variant
                            }
                        }
                    }

                    Components.Slider {
                        id: progress

                        empty: root.live

                        to: root.player.length
                        value: pressed ? value : root.player.position

                        fillColor: Colors.md3.primary
                        trackColor: {
                            if (!!root.player.trackArtUrl)
                                Qt.alpha(Colors.md3.on_surface, 0.15);
                            else
                                Colors.md3.outline_variant;
                        }

                        onPressedChanged: {
                            if (!pressed && root.player) {
                                root.player.position = value;
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 24

                        Text {
                            visible: !root.live

                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            color: Colors.md3.on_surface_variant
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: Formatters.formatTime(progress.value)
                        }

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: Theme.spacingSmall

                            Components.IconButton {
                                id: prevButton

                                enabled: root.player.canGoPrevious

                                size: 32
                                iconSize: 32
                                iconGlyph: "󰒮"

                                // Keep color static
                                backgroundColor: Colors.md3.on_surface
                                hoveredColor: Colors.md3.on_surface
                                pressedColor: Colors.md3.on_surface

                                backgroundOpacity: {
                                    if (pressed)
                                        return 0.2;
                                    if (hovered)
                                        return 0.1;
                                    return 0;
                                }

                                onClicked: root.player.previous()
                            }

                            Components.Tooltip {
                                target: prevButton
                                text: "Previous"
                            }

                            Components.IconButton {
                                id: playPauseButton

                                enabled: root.player.canTogglePlaying

                                size: 32
                                iconSize: 32
                                iconGlyph: {
                                    if (root.player.playbackState === MprisPlaybackState.Playing)
                                        return "󰏤";
                                    return "󰐊";
                                }

                                // Keep color static
                                backgroundColor: Colors.md3.on_surface
                                hoveredColor: Colors.md3.on_surface
                                pressedColor: Colors.md3.on_surface

                                backgroundOpacity: {
                                    if (pressed)
                                        return 0.2;
                                    if (hovered)
                                        return 0.1;
                                    return 0;
                                }

                                onClicked: root.player.togglePlaying()
                            }

                            Components.Tooltip {
                                target: playPauseButton
                                text: root.player.playbackState === MprisPlaybackState.Playing ? "Pause" : "Play"
                            }

                            Components.IconButton {
                                id: nextButton

                                enabled: root.player.canGoNext

                                size: 32
                                iconSize: 32
                                iconGlyph: "󰒭"

                                // Keep color static
                                backgroundColor: Colors.md3.on_surface
                                hoveredColor: Colors.md3.on_surface
                                pressedColor: Colors.md3.on_surface

                                backgroundOpacity: {
                                    if (pressed)
                                        return 0.2;
                                    if (hovered)
                                        return 0.1;
                                    return 0;
                                }

                                onClicked: root.player.next()
                            }

                            Components.Tooltip {
                                target: nextButton
                                text: "Next"
                            }
                        }

                        Text {
                            visible: !root.live

                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            color: Colors.md3.on_surface_variant
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            text: Formatters.formatTime(root.player.length)
                        }
                    }
                }
            }
        }
    }

    Timer {
        running: root.player.playbackState == MprisPlaybackState.Playing

        interval: 1000
        repeat: true

        onTriggered: root.player.positionChanged()
    }
}
