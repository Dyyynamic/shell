import QtQuick
import QtQuick.Controls
import Quickshell.Hyprland
import Quickshell.Widgets
import "../utils"

Indicator {
    id: root

    required property var screen

    readonly property var workspaces: Hyprland.workspaces.values.filter(ws => {
        if (!ws.monitor)
            return false;
        // Filter out special workspaces
        if (ws.id < 0)
            return false;
        return ws.monitor.name === root.screen.name;
    })
    readonly property int activeIndex: workspaces.findIndex(ws => ws.active)
    readonly property int itemWidth: 24

    margin: 4

    Row {
        Repeater {
            model: root.workspaces

            Button {
                id: workspaceItem
                required property var modelData
                required property int index

                onClicked: workspaceItem.modelData.activate()

                height: root.itemWidth
                width: root.itemWidth

                background: Rectangle {
                    anchors.fill: parent
                    radius: height / 2

                    color: {
                        if (workspaceItem.pressed)
                            return Theme.colorMix(Colors.md3.surface_container_high, Colors.md3.on_surface, Theme.pressIntensity);
                        if (workspaceItem.hovered)
                            return Theme.colorMix(Colors.md3.surface_container_high, Colors.md3.on_surface, Theme.hoverIntensity);
                        return Colors.md3.surface_container_high;
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.durationFast
                            easing.type: Theme.easingStandard
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    text: workspaceItem.index + 1
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeLarge
                    font.weight: Font.Bold
                    color: {
                        if (workspaceItem.modelData.toplevels.values.length > 0)
                            return Colors.md3.on_surface;
                        return Colors.md3.outline;
                    }
                }
            }
        }
    }

    ClippingRectangle {
        x: root.activeIndex * root.itemWidth
        width: root.itemWidth
        height: root.itemWidth
        radius: height / 2
        color: Colors.md3.primary_fixed_dim

        Behavior on x {
            NumberAnimation {
                duration: Theme.durationMedium
                easing.type: Theme.easingStandard
            }
        }

        Row {
            x: -root.activeIndex * root.itemWidth

            Repeater {
                model: root.workspaces

                Item {
                    id: textItem
                    required property var modelData
                    required property int index

                    height: root.itemWidth
                    width: root.itemWidth

                    Text {
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        text: textItem.index + 1
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeLarge
                        font.weight: Font.Bold
                        color: Colors.md3.on_primary_fixed
                    }
                }
            }

            Behavior on x {
                NumberAnimation {
                    duration: Theme.durationMedium
                    easing.type: Theme.easingStandard
                }
            }
        }
    }
}
