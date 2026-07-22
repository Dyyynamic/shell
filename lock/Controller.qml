pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import "../utils"
import "." as Lock

Singleton {
    id: root

    Process {
        id: screencopyCmd
        running: false
        command: ["grim", "-t", "jpeg", "/tmp/lock_screencopy.jpg"]
        onExited: lock.locked = true
    }

    function lock() {
        if (lock.locked) return;

        screencopyCmd.running = true;
    }

    function unlock() {
        lock.locked = false;
    }

    function lockWithDelay(ms = Theme.animDurationShort) {
        if (lock.locked) return;

        lockDelayTimer.interval = ms;
        lockDelayTimer.start();
    }

    function lockInstant() {
        if (lock.locked) return;

        lockContext.animate = false;
        screencopyCmd.running = true;
    }

    Timer {
        id: lockDelayTimer
        interval: Theme.animDurationShort
        onTriggered: root.lock()
    }

    IpcHandler {
        target: "lockscreen"

        function lock(): void {
            root.lock();
        }

        function lockInstant(): void {
            root.lockInstant();
        }
    }

    WlSessionLock {
        id: lock
        locked: false

        WlSessionLockSurface {
            id: lockSurface
            color: "transparent"

            Lock.Surface {
                anchors.fill: parent
                context: lockContext
                screen: lockSurface.screen
            }
        }
    }

    Lock.Context {
        id: lockContext
    }

    function init() {
    }
}
