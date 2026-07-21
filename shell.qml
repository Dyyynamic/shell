import Quickshell
import Quickshell.Hyprland
import "bar" as Bar
import "notifs" as Notifs
import "controlCenter" as ControlCenter

ShellRoot {
    id: root

    readonly property string mainMonitor: Quickshell.env("MAIN_MONITOR") || ""

    Variants {
        model: Quickshell.screens

        Scope {
            id: scope

            required property var modelData

            Bar.Bar {
                id: bar
                screen: scope.modelData
                onControlCenterToggleRequested: controlCenter.open = !controlCenter.open
            }

            ControlCenter.ControlCenter {
                id: controlCenter
                screen: scope.modelData
                bar: bar
            }

            Notifs.PopupStack {
                id: notifPopupStack
                screen: scope.modelData
                bar: bar
                // Show on the main monitor if MAIN_MONITOR is set,
                // otherwise show on all monitors
                visible: !root.mainMonitor || scope.modelData.name === root.mainMonitor
            }

            GlobalShortcut {
                name: "toggleControlCenter"
                description: "Toggle Control Center"
                onPressed: {
                    // Show on the focused monitor
                    if (Hyprland.focusedMonitor.name === scope.modelData.name) {
                        controlCenter.open = !controlCenter.open;
                    }
                }
            }
        }
    }
}
