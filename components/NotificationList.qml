import QtQuick
import QtQuick.Layouts
import "../utils"

Item {
    id: root

    property var expandedGroups: ({})

    property var groupedNotifications: {
        let groups = {};

        for (let notif of NotificationStore.notifications.values) {
            let key = notif.appName;
            if (!groups[key]) {
                groups[key] = [];
            }
            groups[key].push(notif);
        }

        // Convert to array of { app, notifications, latest }
        return Object.keys(groups).map(app => {
            let list = groups[app];

            // Sort by newest first
            list.sort((a, b) => b.time - a.time);

            return {
                app: app,
                notifications: list,
                latest: list[0],
                expanded: false
            };
        });
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

            model: root.groupedNotifications

            delegate: NotificationGroup {
                required property var modelData
                notifs: modelData

                expanded: root.expandedGroups[modelData.app] ?? false

                onExpandedChanged: {
                    root.expandedGroups[modelData.app] = expanded
                }
            }
        }
    }
}
