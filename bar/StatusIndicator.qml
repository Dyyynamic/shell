import QtQuick
import "../utils"
import "../components" as Components

Indicator {
    id: root

    clickable: true

    Row {
        spacing: Theme.spacingSmall

        Components.Icon {
            id: wifi
            icon: Wifi.icon(Wifi.connectedNetwork)
            color: root.textColor
        }

        Components.Icon {
            icon: Audio.icon(Audio.defaultSink)
            color: root.textColor
        }

        Loader {
            active: Battery.available

            sourceComponent: Components.Icon {
                icon: Battery.icon
                color: root.textColor
            }
        }
    }
}
