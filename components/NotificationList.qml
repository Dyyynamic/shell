import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../utils"

Item {
    id: root

    signal notificationActivated

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout {
            Text {
                text: "Notifications"
                font.pixelSize: 16
                font.bold: true
                font.family: "NotoSans Nerd Font Propo"
                color: Colors.md3.on_background
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                id: clearButton

                text: "Clear"
                font.family: "NotoSans Nerd Font Propo"
                font.pixelSize: 12
                onClicked: NotificationStore.clear()

                enabled: NotificationStore.count > 0
                hoverEnabled: NotificationStore.count > 0

                opacity: NotificationStore.count > 0 ? 1 : 0.5

                focusPolicy: Qt.NoFocus

                background: Rectangle {
                    implicitHeight: 32
                    implicitWidth: 72
                    radius: height / 2

                    color: {
                        if (clearButton.pressed)
                            return Qt.lighter(Colors.md3.background, 3.5);
                        if (clearButton.hovered)
                            return Qt.lighter(Colors.md3.background, 2.75);
                        return Qt.lighter(Colors.md3.background, 2);
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                            easing: Easing.OutCubic
                        }
                    }
                }
            }
        }

        Item {
            id: content

            readonly property bool hasContent: {
                return NotificationStore.count > 0 || PlayerStore.hasActivePlayer;
            }

            Layout.fillWidth: true
            Layout.fillHeight: true

            Item {
                anchors.fill: parent

                opacity: !content.hasContent ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 10

                    Icon {
                        icon: "󰂚"
                        color: Qt.darker(Colors.md3.on_background, 2)
                        size: 80
                    }

                    Text {
                        font.family: "NotoSans Nerd Font Propo"
                        text: "No notifications"
                        color: Qt.darker(Colors.md3.on_background, 2)
                    }
                }
            }

            ListView {
                id: notificationList

                anchors.fill: parent
                spacing: 10
                clip: true

                opacity: content.hasContent ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }

                displaced: Transition {
                    NumberAnimation {
                        properties: "y"
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }

                remove: Transition {
                    NumberAnimation {
                        property: "opacity"
                        to: 0
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }

                header: PlayerStore.hasActivePlayer ? playerComponent : null

                Component {
                    id: playerComponent
                    Item {
                        width: parent.width
                        height: player.height + 10

                        MediaPlayer {
                            id: player
                        }
                    }
                }

                model: NotificationStore.notifications

                delegate: NotificationItem {
                    required property var modelData

                    notification: modelData
                    width: ListView.view.width

                    onActivated: root.notificationActivated()
                }
            }
        }
    }
}
