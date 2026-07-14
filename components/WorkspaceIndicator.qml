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
        // filter out special workspaces
        if (ws.id < 0)
            return false;
        return ws.monitor.name === root.screen.name;
    })
    readonly property int activeIndex: workspaces.findIndex(ws => ws.active)
    readonly property int itemWidth: 24

    horizontalPadding: 4

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
                            return Qt.lighter(Theme.overlay, Theme.pressedMultiplier);
                        if (workspaceItem.hovered)
                            return Qt.lighter(Theme.overlay, Theme.hoverMultiplier);
                        return Theme.overlay;
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.animationDuration
                            easing.type: Theme.animationEasing
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    text: workspaceItem.index + 1
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    font.bold: true
                    color: {
                        if (workspaceItem.modelData.toplevels.values.length > 0)
                            return Theme.text;
                        return Theme.textSecondary;
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
        color: Theme.accent

        Behavior on x {
            NumberAnimation {
                duration: Theme.animationDuration
                easing.type: Theme.animationEasing
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
                        font.pixelSize: Theme.fontSize
                        font.bold: true
                        color: Theme.textAccent
                    }
                }
            }

            Behavior on x {
                NumberAnimation {
                    duration: Theme.animationDuration
                    easing.type: Theme.animationEasing
                }
            }
        }
    }
}
