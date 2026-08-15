import QtQuick
import QtQuick.Layouts
import "../utils"
import "../components" as Components

Indicator {
    id: root

    margin: 12
    clickable: true

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Theme.durationMedium
            easing: Theme.easingStandard
        }
    }

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        spacing: Theme.spacingSmall

        Components.Icon {
            visible: Notifications.doNotDisturb || Notifications.notifications.values.length > 0
            icon: Notifications.doNotDisturb ? "󰂠" : "󱅫"
            color: root.textColor
        }

        Components.Icon {
            icon: Wifi.icon(Wifi.connectedNetwork)
            color: root.textColor
        }

        Components.Icon {
            icon: Audio.icon(Audio.defaultSink)
            color: root.textColor
        }

        Components.Icon {
            visible: Battery.available
            icon: Battery.icon
            color: root.textColor
        }
    }
}
