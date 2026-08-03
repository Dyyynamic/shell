pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Greetd
import QtQuick
import "lock" as Lock

ShellRoot {
    id: root

    function unlock() {
        lock.locked = false;
        Greetd.launch(["start-hyprland", ">/dev/null", "2>&1"]);
    }

    WlSessionLock {
        id: lock
        locked: true

        WlSessionLockSurface {
            id: lockSurface
            color: "transparent"

            Lock.GreeterSurface {
                anchors.fill: parent
                controller: root
                context: lockContext
                screen: lockSurface.screen
            }
        }
    }

    Lock.GreeterContext {
        id: lockContext
    }
}
