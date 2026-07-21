pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property alias date: clock.date

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
