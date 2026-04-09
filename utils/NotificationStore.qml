pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property alias notifications: notifServer.trackedNotifications

    NotificationServer {
        id: notifServer

        onNotification: notif => {
            notif.time = Date.now();
            notif.tracked = true;
        }
    }
}
