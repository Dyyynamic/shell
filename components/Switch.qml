import QtQuick
import QtQuick.Controls
import "../utils"

Switch {
    id: root

    width: 40
    height: 24
    implicitWidth: width
    implicitHeight: height

    indicator: Rectangle {
        anchors.fill: parent

        radius: height / 2

        color: root.checked ? Colors.md3.primary : Colors.md3.surface_variant

        Rectangle {
            id: thumb

            width: 18
            height: 18
            radius: height / 2

            anchors.verticalCenter: parent.verticalCenter

            x: root.checked ? parent.width - width - 4 : 4

            color: root.checked ? Colors.md3.on_primary : Colors.md3.on_surface

            Behavior on x {
                NumberAnimation {
                    easing.type: Theme.easingStandard
                    duration: Theme.durationMedium
                }
            }
        }
    }
}
