import QtQuick
import Quickshell.Services.UPower
import "../utils"

Widget {
    id: root

    clickable: true

    width: implicitWidth + 8

    Row {
        spacing: 8

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
