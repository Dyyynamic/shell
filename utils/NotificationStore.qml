pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property bool doNotDisturb: false

    readonly property alias notifications: notifServer.trackedNotifications
    readonly property int count: notifServer.trackedNotifications.values.length

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

        imageSupported: true
        actionsSupported: true
        actionIconsSupported: true
        persistenceSupported: true

        onNotification: notif => {
            notif.time = Date.now();
            notif.tracked = true;
            notif.closed.connect(() => root.notificationClosed(notif));
            root.notificationReceived(notif);
        }
    }
}
