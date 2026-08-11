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

    implicitWidth: parent.width
    implicitHeight: 128

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: Players.players[0].canRaise
        hoverEnabled: true
        onClicked: Players.players[0].raise()
    }

    ClippingRectangle {
        anchors.fill: parent
        radius: Theme.radiusSmall
        color: "transparent"

        Image {
            id: trackArtBackground
            anchors.fill: parent
            source: Players.players[0].trackArtUrl
            fillMode: Image.PreserveAspectCrop
            visible: !!Players.players[0].trackArtUrl
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
            opacity: !!Players.players[0].trackArtUrl ? 0.75 : 1

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
                        source: Players.players[0].trackArtUrl
                        visible: !!Players.players[0].trackArtUrl
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: Colors.md3.surface_container_low

                        visible: !Players.players[0].trackArtUrl

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
                        Layout.preferredHeight: 40
                        Layout.fillWidth: true

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
                                text: Players.players[0].trackTitle
                                color: Colors.md3.on_surface
                            }

                            Text {
                                visible: !!Players.players[0].trackArtist
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeSmall
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                text: Players.players[0].trackArtist
                                color: Colors.md3.on_surface_variant
                            }
                        }
                    }

                    Components.Slider {
                        id: progress

                        to: Players.players[0].length
                        value: pressed ? value : Players.players[0].position

                        fillColor: Colors.md3.primary
                        trackColor: {
                            if (!!Players.players[0].trackArtUrl)
                                Qt.alpha(Colors.md3.on_surface, 0.15);
                            else
                                Colors.md3.outline_variant;
                        }

                        onPressedChanged: {
                            if (!pressed && Players.players[0]) {
                                Players.players[0].position = value;
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 24

                        Text {
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

                                onClicked: Players.players[0].previous()
                            }

                            Components.Tooltip {
                                target: prevButton
                                text: "Previous"
                            }

                            Components.IconButton {
                                id: playPauseButton

                                size: 32
                                iconSize: 32
                                iconGlyph: {
                                    if (Players.players[0].playbackState === MprisPlaybackState.Playing)
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

                                onClicked: Players.players[0].togglePlaying()
                            }

                            Components.Tooltip {
                                target: playPauseButton
                                text: Players.players[0].playbackState === MprisPlaybackState.Playing ? "Pause" : "Play"
                            }

                            Components.IconButton {
                                id: nextButton

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

                                onClicked: Players.players[0].next()
                            }

                            Components.Tooltip {
                                target: nextButton
                                text: "Next"
                            }
                        }

                        Text {
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            color: Colors.md3.on_surface_variant
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            text: Formatters.formatTime(Players.players[0].length)
                        }
                    }
                }
            }
        }
    }

    Timer {
        running: Players.players[0].playbackState == MprisPlaybackState.Playing

        interval: 1000
        repeat: true

        onTriggered: Players.players[0].positionChanged()
    }
}
