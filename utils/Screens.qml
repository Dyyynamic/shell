pragma Singleton

import Quickshell

Singleton {
    id: root

    readonly property var main: Quickshell.screens.find(screen => {
        return screen.name === Quickshell.env("MAIN_MONITOR");
    }) ?? Quickshell.screens[0]
}
