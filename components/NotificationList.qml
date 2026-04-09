import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import "../utils"

Item {
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
            visible: NotificationStore.notifications.values.length === 0
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
            visible: NotificationStore.notifications.values.length > 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            clip: true

            model: NotificationStore.notifications

            delegate: NotificationItem {
                required property Notification modelData
                notification: modelData
            }
        }
    }
}
