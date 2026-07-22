import QtQuick
import QtQuick.Effects
import Quickshell.Services.Notifications
import "../utils"

Item {
    id: root

    required property Notification notification

    signal expired

    width: parent.width
    height: item.height

    ParallelAnimation {
        NumberAnimation {
            target: root
            property: "opacity"
            from: 0
            to: 1
            duration: Theme.animDurationMedium
            easing.type: Theme.animEasing
        }
        NumberAnimation {
            target: root
            property: "x"
            from: root.width
            to: 0
            duration: Theme.animDurationMedium
            easing.type: Theme.animEasing
        }

        running: true
    }

    RectangularShadow {
        anchors.fill: parent
        radius: item.radius
        color: "black"
        opacity: 0.5
        offset.y: 2
        blur: 10
        z: -1
    }

    Notif {
        id: item
        notification: root.notification
    }

    Timer {
        interval: 3000
        running: true
        onTriggered: root.expired()
    }
}
