pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../utils"
import "." as WallpaperPicker

PanelWindow {
    id: root
    WlrLayershell.namespace: "qs-wallpaper-picker"

    readonly property int margin: Theme.spacingSmall

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    color: "transparent"

    focusable: true

    MouseArea {
        anchors.fill: parent
        onClicked: WallpaperPicker.Controller.close()
    }

    Item {
        // Draw everything to a layer so we can animate opacity correctly.
        // To avoid cutting off the shadow, wrap the WrapperItem in an Item that
        // fills the parent.
        layer.enabled: true
        anchors.fill: parent

        focus: true

        Keys.onLeftPressed: {
            if (wallpaperList.currentIndex > 0)
                wallpaperList.currentIndex -= 1;
        }
        Keys.onRightPressed: {
            if (wallpaperList.currentIndex < wallpaperList.count - 1)
                wallpaperList.currentIndex += 1;
        }

        opacity: WallpaperPicker.Controller.isOpen ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: {
                    if (WallpaperPicker.Controller.isOpen)
                        return Theme.durationSlideIn;
                    return Theme.durationMedium;
                }
                easing.type: {
                    if (WallpaperPicker.Controller.isOpen)
                        return Theme.easingExpressive;
                    return Theme.easingStandard;
                }
                easing.overshoot: {
                    if (WallpaperPicker.Controller.isOpen)
                        return Theme.overshoot;
                    return 0;
                }
            }
        }

        WrapperItem {
            id: wrapperItem
            height: 180
            width: 750

            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }

            margin: root.margin

            // Use a transform since y cannot be animated directly
            transform: Translate {
                y: WallpaperPicker.Controller.isOpen ? 0 : -wrapperItem.height

                Behavior on y {
                    NumberAnimation {
                        property: "y"
                        duration: {
                            if (WallpaperPicker.Controller.isOpen)
                                return Theme.durationSlideIn;
                            return Theme.durationMedium;
                        }
                        easing.type: {
                            if (WallpaperPicker.Controller.isOpen)
                                return Theme.easingExpressive;
                            return Theme.easingStandard;
                        }
                        easing.overshoot: {
                            if (WallpaperPicker.Controller.isOpen)
                                return Theme.overshoot;
                            return 0;
                        }

                        // Behavior animations don't emit onFinished, so we use
                        // onRunningChanged instead
                        onRunningChanged: {
                            if (!running) {
                                WallpaperPicker.Controller.isTransitioning = false;
                            }
                        }
                    }
                }
            }

            Item {
                // Prevent clicks inside the panel from closing it
                MouseArea {
                    anchors.fill: parent
                }

                RectangularShadow {
                    anchors.fill: parent
                    radius: background.radius
                    color: "black"
                    opacity: 0.5
                    offset.y: 2
                    blur: 24
                    z: -1
                }

                Rectangle {
                    id: background
                    anchors.fill: parent
                    radius: Theme.radiusLarge
                    color: Colors.md3.background
                    border.color: Colors.md3.surface_container_highest
                }

                WrapperItem {
                    anchors.fill: parent
                    margin: Theme.spacingMedium

                    ListView {
                        id: wallpaperList

                        orientation: ListView.Horizontal
                        spacing: -32

                        model: WallpaperPicker.Controller.wallpapers
                        clip: true

                        preferredHighlightBegin: width / 2 - currentItem.width / 2
                        preferredHighlightEnd: width / 2 + currentItem.width / 2
                        highlightRangeMode: ListView.StrictlyEnforceRange

                        highlightMoveDuration: Theme.durationMedium

                        currentIndex: WallpaperPicker.Controller.currentIndex

                        delegate: Item {
                            id: wallpaperItem
                            required property string modelData
                            required property int index

                            width: 206
                            height: wallpaperList.height

                            z: -Math.abs(index - wallpaperList.currentIndex)

                            Item {
                                anchors.fill: parent

                                scale: 1 - Math.abs(wallpaperItem.index - wallpaperList.currentIndex) * 0.1

                                Behavior on scale {
                                    NumberAnimation {
                                        duration: Theme.durationMedium
                                        easing.type: Theme.easingStandard
                                    }
                                }

                                ColumnLayout {
                                    ClippingRectangle {
                                        width: 206
                                        height: 116
                                        color: "transparent"
                                        radius: Theme.radiusTiny

                                        Image {
                                            anchors.fill: parent
                                            source: `${WallpaperPicker.Controller.thumbnailDir}/${wallpaperItem.modelData.split("/").pop()}`
                                            fillMode: Image.PreserveAspectCrop
                                        }
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: wallpaperItem.modelData.split("/").pop()
                                        font.family: Theme.fontFamily
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Colors.md3.on_surface
                                    }
                                }

                                Rectangle {
                                    anchors.fill: parent
                                    color: Colors.md3.background
                                    opacity: 1 - 0.5 ** Math.abs(wallpaperItem.index - wallpaperList.currentIndex)

                                    Behavior on opacity {
                                        NumberAnimation {
                                            duration: Theme.durationMedium
                                            easing.type: Theme.easingStandard
                                        }
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent

                                onClicked: wallpaperList.currentIndex = wallpaperItem.index

                                // onClicked: {
                                //     selectWallpaper(modelData);
                                // }
                            }
                        }

                        focus: true

                        Keys.onLeftPressed: {
                            if (currentIndex > 0)
                                currentIndex--;
                            else if (keyNavigationWraps)
                                currentIndex = count - 1;
                        }

                        Keys.onRightPressed: {
                            if (currentIndex < count - 1)
                                currentIndex++;
                            else if (keyNavigationWraps)
                                currentIndex = 0;
                        }
                    }
                }
            }
        }
    }
}
