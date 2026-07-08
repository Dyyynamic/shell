pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property bool doNotDisturb: false

    signal notificationReceived(Notification notification)

    function toggleDoNotDisturb() {
        doNotDisturb = !doNotDisturb;
    }

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
