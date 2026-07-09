pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property alias notifications: notifServer.trackedNotifications
    property int count: notifServer.trackedNotifications.values.length
    property bool doNotDisturb: false

    signal notificationReceived(Notification notification)
    signal notificationClosed(Notification notification)

    function toggleDoNotDisturb() {
        doNotDisturb = !doNotDisturb;
    }

    function clear() {
        for (const notification of [...notifications.values]) {
            notification.dismiss();
        }
    }

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
