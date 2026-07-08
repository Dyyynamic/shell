pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    signal notificationReceived(Notification notification)

    NotificationServer {
        id: notifServer

        actionsSupported: true

        onNotification: notif => {
            notif.time = Date.now();
            notif.tracked = true;
            root.notificationReceived(notif);
        }
    }
}
