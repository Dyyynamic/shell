pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import "bar" as Bar
import "notifs" as Notifs
import "controlCenter" as ControlCenter
import "lock" as Lock
import "capture" as Capture
import "osd" as Osd

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens

        Bar.Bar {
            required property var modelData
            screen: modelData
        }
    }

    Notifs.PopupList {}

    Component.onCompleted: {
        ControlCenter.Controller.init();
        Lock.Controller.init();
        Capture.Controller.init();
        Osd.Controller.init();
    }
}
