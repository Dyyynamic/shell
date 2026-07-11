import QtQuick
import QtQuick.Controls
import Quickshell.Hyprland
import Quickshell.Widgets
import "../utils"

Widget {
    id: workspaceWidget

    required property var screen

    property var workspaces: Hyprland.workspaces.values.filter(ws => {
        if (!ws.monitor)
            return false;
        // filter out special workspaces
        if (ws.id < 0)
            return false;
        return ws.monitor.name === workspaceWidget.screen.name;
    })

    property int activeIndex: workspaces.findIndex(ws => ws.active)

    property int itemWidth: 24

    horizontalPadding: 4

    Row {
        Repeater {
            model: workspaceWidget.workspaces

            Button {
                id: workspaceItem
                required property var modelData
                required property int index

                onClicked: workspaceItem.modelData.activate()

                height: workspaceWidget.itemWidth
                width: workspaceWidget.itemWidth

                background: Rectangle {
                    anchors.fill: parent
                    radius: height / 2

                    color: {
                        if (workspaceItem.pressed)
                            return Qt.lighter(Colors.md3.background, 3);
                        if (workspaceItem.hovered)
                            return Qt.lighter(Colors.md3.background, 2.5);
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
        x: workspaceWidget.activeIndex * workspaceWidget.itemWidth
        width: workspaceWidget.itemWidth
        height: workspaceWidget.itemWidth
        radius: height / 2
        color: Colors.md3.primary

        Behavior on x {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        Row {
            x: -workspaceWidget.activeIndex * workspaceWidget.itemWidth

            Repeater {
                model: workspaceWidget.workspaces

                Item {
                    id: textItem
                    required property var modelData
                    required property int index

                    height: workspaceWidget.itemWidth
                    width: workspaceWidget.itemWidth

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
