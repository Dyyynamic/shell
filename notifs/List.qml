import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../utils"
import "../components" as Components

Components.Widget {
    id: root

    signal notificationActivated

    ColumnLayout {
        spacing: Theme.spacingSmall

        Item {
            id: content

            readonly property bool hasContent: {
                return Notifications.count > 0 || Players.hasActivePlayer;
            }

            Layout.fillWidth: true
            Layout.fillHeight: true

            Item {
                anchors.fill: parent

                opacity: !content.hasContent ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: Theme.animationDuration
                        easing.type: Theme.animationEasing
                    }
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Theme.spacingSmall

                    Components.Icon {
                        Layout.alignment: Qt.AlignHCenter
                        icon: "󰂚"
                        color: Theme.textSecondary
                        size: 80
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter

                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeTiny
                        text: "No notifications"
                        color: Theme.textSecondary
                    }
                }
            }

            ListView {
                anchors.fill: parent
                spacing: Theme.spacingSmall
                clip: true

                opacity: content.hasContent ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: Theme.animationDuration
                        easing.type: Theme.animationEasing
                    }
                }

                displaced: Transition {
                    NumberAnimation {
                        properties: "y"
                        duration: Theme.animationDuration
                        easing.type: Theme.animationEasing
                    }
                }

                remove: Transition {
                    NumberAnimation {
                        property: "opacity"
                        to: 0
                        duration: Theme.animationDuration
                        easing.type: Theme.animationEasing
                    }
                }

                header: Players.hasActivePlayer ? playerComponent : null

                Component {
                    id: playerComponent
                    Item {
                        width: parent.width
                        height: player.height + Theme.spacingSmall

                        Components.MediaPlayer {
                            id: player
                        }
                    }
                }

                model: Notifications.notifications

                delegate: Notif {
                    required property var modelData

                    notification: modelData
                    width: ListView.view.width

                    onActivated: root.notificationActivated()
                }
            }
        }

        RowLayout {
            WrapperItem {
                margin: Theme.spacingSmall

                Text {
                    text: `${Notifications.count} notification${Notifications.count !== 1 ? 's' : ''}`
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeTiny
                    color: Theme.text
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Components.Button {
                text: "Clear"
                font.pixelSize: Theme.fontSizeTiny
                enabled: Notifications.count > 0
                implicitWidth: 72
                onClicked: Notifications.clear()
            }
        }
    }
}
