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
        screencopyCmd.running = true;
    }

    function unlock() {
        lock.locked = false;
    }

    function lockWithDelay(ms = Theme.animationDuration) {
        lockDelayTimer.interval = ms;
        lockDelayTimer.start();
    }

    function lockInstant() {
        lockContext.animate = false;
        screencopyCmd.running = true;
    }

    Timer {
        id: lockDelayTimer
        interval: Theme.animationDuration
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
