import QtQuick
import "../utils"

Indicator {
    id: root

    clickable: true

    Row {
        spacing: Theme.spacingSmall

        Icon {
            id: network
            icon: Network.icon
        }

        Icon {
            icon: Volume.icon
        }

        Loader {
            active: Battery.available

            sourceComponent: Icon {
                icon: Battery.icon
            }
        }
    }
}
