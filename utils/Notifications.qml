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
        const command = ["notify-send", "-p", "-a", "Arch Linux"];

        command.push(summary);
        command.push(body);

        if (options.icon)
            command.push("-i", options.icon);

        for (const [name, action] of Object.entries(options.actions ?? {})) {
            const arg = `--action=${name}=${action.text}`;
            command.push(arg);
        }

        return notifyProcComponent.createObject(root, {
            actions: options.actions ?? {},
            command: command,
            running: true
        });
    }

    function dismiss(id) {
        for (const notification of [...notifications.values]) {
            if (notification.id === id) {
                notification.dismiss();
                return;
            }
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

    Component {
        id: notifyProcComponent

        Process {
            id: notifyProcess

            property var actions: ({})
            property int id: -1

            stdout: SplitParser {
                onRead: data => {
                    // First line is the notification ID
                    if (notifyProcess.id === -1) {
                        notifyProcess.id = parseInt(data.trim())
                        return;
                    }

                    const response = data.trim();
                    const action = notifyProcess.actions[response];

                    action?.callback();

                    destroy();
                }
            }
        }
    }
}
