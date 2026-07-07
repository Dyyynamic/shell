pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property alias notifications: notifServer.trackedNotifications

    signal notificationReceived(var notification)

    signal notificationClosed(var notification)

    NotificationServer {
        id: notifServer

        actionsSupported: true

        onNotification: notif => {
            notif.time = Date.now();
            notif.tracked = true;
            notif.closed.connect(() => root.notificationClosed(notif));
            root.notificationReceived(notif);
        }
    }
}
