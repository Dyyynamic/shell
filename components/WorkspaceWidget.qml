import QtQuick
import QtQuick.Controls
import Quickshell.Hyprland
import Quickshell.Widgets
import "../utils"

Widget {
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
                            return Qt.lighter(Colors.md3.background, 3.5);
                        if (workspaceItem.hovered)
                            return Qt.lighter(Colors.md3.background, 2.75);
                        return Qt.lighter(Colors.md3.background, 2);
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    text: workspaceItem.index + 1
                    font.family: "NotoSans Nerd Font Propo"
                    font.bold: true
                    font.pixelSize: 16
                    color: {
                        if (workspaceItem.modelData.toplevels.values.length > 0)
                            return Colors.md3.on_background;
                        return Qt.darker(Colors.md3.on_background, 1.5);
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
        color: Colors.md3.primary

        Behavior on x {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
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
                        font.family: "NotoSans Nerd Font Propo"
                        font.bold: true
                        font.pixelSize: 16
                        color: Colors.md3.on_primary;
                    }
                }
            }

            Behavior on x {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}
