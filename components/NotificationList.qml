import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../utils"

Widget {
    id: root

    signal notificationActivated

    ColumnLayout {
        spacing: Theme.spacingSmall

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
                        duration: Theme.animationDuration
                        easing.type: Theme.animationEasing
                    }
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Theme.spacingSmall

                    Icon {
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
                id: notificationList

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

                header: PlayerStore.hasActivePlayer ? playerComponent : null

                Component {
                    id: playerComponent
                    Item {
                        width: parent.width
                        height: player.height + Theme.spacingSmall

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

        RowLayout {
            WrapperItem {
                margin: Theme.spacingSmall

                Text {
                    text: `${NotificationStore.count} notification${NotificationStore.count !== 1 ? 's' : ''}`
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeTiny
                    color: Theme.text
                }
            }

            Item {
                Layout.fillWidth: true
            }

            RegularButton {
                text: "Clear"
                font.pixelSize: Theme.fontSizeTiny
                enabled: NotificationStore.count > 0
                implicitWidth: 72
                onClicked: NotificationStore.clear()
            }
        }
    }
}
