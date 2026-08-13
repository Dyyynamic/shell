import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../utils"
import "../components" as Components
import "settings" as Settings

Components.Widget {
    id: root

    property var settingsMenu: Settings.SettingsMenu {
        onVolumeMenuRequested: stackView.push(root.volumeMenu)
        onWifiMenuRequested: stackView.push(root.wifiMenu)
        onBluetoothMenuRequested: stackView.push(root.bluetoothMenu)
    }

    property var volumeMenu: Settings.VolumeMenu {
        onBackRequested: stackView.pop()
    }

    property var wifiMenu: Settings.WifiMenu {
        onBackRequested: stackView.pop()
    }

    property var bluetoothMenu: Settings.BluetoothMenu {
        onBackRequested: stackView.pop()
    }

    property var popEnterAnimation: Transition {
        XAnimator {
            from: -root.width
            to: 0
            duration: Theme.durationMedium
            easing.type: Theme.easingStandard
        }
    }

    property var popExitAnimation: Transition {
        XAnimator {
            from: 0
            to: root.width
            duration: Theme.durationMedium
            easing.type: Theme.easingStandard
        }
    }

    property var pushEnterAnimation: Transition {
        XAnimator {
            from: root.width
            to: 0
            duration: Theme.durationMedium
            easing.type: Theme.easingStandard
        }
    }

    property var pushExitAnimation: Transition {
        XAnimator {
            from: 0
            to: -root.width
            duration: Theme.durationMedium
            easing.type: Theme.easingStandard
        }
    }

    property bool animate: true

    StackView {
        id: stackView

        width: parent.width
        implicitHeight: currentItem.implicitHeight

        clip: true

        Behavior on implicitHeight {
            NumberAnimation {
                duration: Theme.durationMedium
                easing.type: Theme.easingStandard
            }
        }

        popEnter: root.animate ? root.popEnterAnimation : null
        popExit: root.animate ? root.popExitAnimation : null
        pushEnter: root.animate ? root.pushEnterAnimation : null
        pushExit: root.animate ? root.pushExitAnimation : null

        initialItem: root.settingsMenu
    }
}
