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

    opacity: 0
    x: width

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

    Component.onCompleted: {
        root.opacity = 1;
        root.x = 0;
    }

    Timer {
        interval: 3000
        running: true
        onTriggered: root.expired()
    }

    Behavior on opacity {
        NumberAnimation {
            duration: Theme.animationDuration
            easing.type: Theme.animationEasing
        }
    }

    Behavior on x {
        NumberAnimation {
            duration: Theme.animationDuration
            easing.type: Theme.animationEasing
        }
    }
}
