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
        }

        Components.Icon {
            icon: Audio.icon(Audio.defaultSink)
        }

        Loader {
            active: Battery.available

            sourceComponent: Components.Icon {
                icon: Battery.icon
            }
        }
    }
}
