import QtQuick
import QtQuick.Controls
import "../utils"
import "../components" as Components
import "settings" as Settings

Components.Widget {
    id: root

    signal closeRequested

    property var settingsMenu: Settings.SettingsMenu {
        onVolumeMenuRequested: stackView.push(root.volumeMenu)
        onWifiMenuRequested: stackView.push(root.wifiMenu)
        onBluetoothMenuRequested: stackView.push(root.bluetoothMenu)
    }
    property var volumeMenu: Settings.VolumeMenu {
        onBackRequested: stackView.pop()
        onCloseRequested: root.closeRequested()
    }
    property var wifiMenu: Settings.WifiMenu {
        onBackRequested: stackView.pop()
        onCloseRequested: root.closeRequested()
    }
    property var bluetoothMenu: Settings.BluetoothMenu {
        onBackRequested: stackView.pop()
        onCloseRequested: root.closeRequested()
    }

    property var popEnterAnimation: Transition {
        XAnimator {
            from: -root.width
            to: 0
            duration: Theme.animationDuration
            easing: Theme.animationEasing
        }
    }

    property var popExitAnimation: Transition {
        XAnimator {
            from: 0
            to: root.width
            duration: Theme.animationDuration
            easing: Theme.animationEasing
        }
    }

    property var pushEnterAnimation: Transition {
        XAnimator {
            from: root.width
            to: 0
            duration: Theme.animationDuration
            easing: Theme.animationEasing
        }
    }

    property var pushExitAnimation: Transition {
        XAnimator {
            from: 0
            to: -root.width
            duration: Theme.animationDuration
            easing: Theme.animationEasing
        }
    }

    property bool animate: true

    function closeSilent() {
        animate = false;
        stackView.pop();
        animate = true;
    }

    StackView {
        id: stackView

        clip: true
        implicitHeight: currentItem ? currentItem.implicitHeight : 0

        Behavior on implicitHeight {
            NumberAnimation {
                duration: Theme.animationDuration
                easing: Theme.animationEasing
            }
        }

        popEnter: root.animate ? root.popEnterAnimation : null
        popExit: root.animate ? root.popExitAnimation : null
        pushEnter: root.animate ? root.pushEnterAnimation : null
        pushExit: root.animate ? root.pushExitAnimation : null

        initialItem: root.settingsMenu
    }
}
