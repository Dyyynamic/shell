import QtQuick
import QtQuick.Controls
import Quickshell.Hyprland
import "../utils"

Widget {
    id: workspaceWidget
    required property var screen

    Row {
        Repeater {
            model: Hyprland.workspaces.values.filter(ws => {
                if (!ws.monitor)
                    return false;
                // filter out special workspaces
                if (ws.id < 0)
                    return false;
                return ws.monitor.name === workspaceWidget.screen.name;
            })

            Button {
                id: workspaceItem
                required property var modelData

                height: 32
                width: 20

                background: null

                onClicked: workspaceItem.modelData.activate()

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    width: workspaceItem.modelData.active ? 10 : 8
                    height: workspaceItem.modelData.active ? 10 : 8
                    radius: width / 2
                    color: {
                        if (workspaceItem.modelData.active)
                            return Colors.md3.on_background;
                        if (workspaceItem.hovered)
                            return Qt.darker(Colors.md3.on_background, 1.25);
                        if (workspaceItem.modelData.toplevels.values.length > 0)
                            return Qt.darker(Colors.md3.on_background, 1.75);
                        return Qt.darker(Colors.md3.on_background, 2.5);
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on width {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on height {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }
        }
    }
}
