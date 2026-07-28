pragma ComponentBehavior: Bound
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
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

    function send(summary, body, options = {}) {
        const command = ["notify-send", "-a", "Arch Linux"];

        command.push(summary);
        command.push(body);

        if (options.icon)
            command.push("-i", options.icon);

        for (const [name, action] of Object.entries(options.actions ?? {})) {
            const arg = `--action=${name}=${action.text}`;
            command.push(arg);
        }

        const process = notifyProcComponent.createObject(root, {
            actions: options.actions ?? {},
            command: command,
            running: true
        });
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

    Component {
        id: notifyProcComponent

        Process {
            id: notifyProcess

            property var actions: ({})

            stdout: StdioCollector {
                onStreamFinished: {
                    const response = this.text.trim();
                    const action = notifyProcess.actions[response];

                    action?.callback();

                    destroy();
                }
            }
        }
    }
}
