pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import "bar" as Bar
import "notifs" as Notifs
import "controlCenter" as ControlCenter
import "lock" as Lock
import "capture" as Capture

ShellRoot {
    id: root

    readonly property string mainMonitor: Quickshell.env("MAIN_MONITOR")

    Variants {
        model: Quickshell.screens

        Scope {
            id: scope

            required property var modelData

            Bar.Bar {
                screen: scope.modelData
            }

            LazyLoader {
                // Show on the main monitor if MAIN_MONITOR is set, otherwise
                // show on all monitors
                active: !root.mainMonitor || scope.modelData.name === root.mainMonitor

                Notifs.PopupStack {}
            }
        }
    }

    Component.onCompleted: {
        ControlCenter.Controller.init();
        Lock.Controller.init();
        Capture.Controller.init();
    }
}
