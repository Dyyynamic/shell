pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        Repeater {
            model: root.workspaces

            Button {
                id: workspaceItem
                required property var modelData
                required property int index

                onClicked: workspaceItem.modelData.activate()

                implicitHeight: root.itemWidth
                implicitWidth: root.itemWidth

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
        anchors.verticalCenter: parent.verticalCenter

        x: root.activeIndex * root.itemWidth

        implicitHeight: root.itemWidth
        implicitWidth: root.itemWidth

        radius: height / 2
        color: Colors.md3.primary_fixed_dim

        Behavior on x {
            NumberAnimation {
                duration: Theme.durationMedium
                easing.type: Theme.easingStandard
            }
        }

        RowLayout {
            spacing: 0

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
