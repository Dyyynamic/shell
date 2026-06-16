pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property alias notifications: notifServer.trackedNotifications

    signal notificationReceived(var notification)

    NotificationServer {
        id: notifServer

        onNotification: notif => {
            notif.time = Date.now();
            notif.tracked = true;
            root.notificationReceived(notif);
            console.log("Store: notif received")
        }
    }
}
