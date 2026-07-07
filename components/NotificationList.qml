import QtQuick
import QtQuick.Layouts
import "../utils"

Item {
    id: root

    function removeNotification(id) {
        for (let i = 0; i < notificationModel.count; i++) {
            if (notificationModel.get(i).notification.id === id) {
                notificationModel.remove(i);
                break;
            }
        }
    }

    Connections {
        target: NotificationStore

        function onNotificationReceived(notification) {
            // Insert at top of list
            notificationModel.insert(0, {
                notification: notification
            });
        }
    }

    ListModel {
        id: notificationModel
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Text {
            text: "Notifications"
            font.pixelSize: 16
            font.bold: true
            color: Colors.md3.on_background
        }

        Item {
            visible: notificationModel.count === 0
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 10

                Icon {
                    icon: "󰂚"
                    color: Qt.darker(Colors.md3.on_background, 2)
                    size: 80
                }

                Text {
                    text: "No notifications"
                    color: Qt.darker(Colors.md3.on_background, 2)
                }
            }
        }

        ListView {
            id: notificationList
            visible: notificationModel.count > 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            clip: true

            displaced: Transition {
                NumberAnimation {
                    properties: "y"
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            model: notificationModel

            delegate: NotificationItem {
                required property var modelData

                notification: modelData
                width: ListView.view.width

                onClosed: root.removeNotification(notification.id)
            }
        }
    }
}
