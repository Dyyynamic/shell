import QtQuick
import QtQuick.Effects
import Quickshell.Services.Notifications

Rectangle {
    id: popup

    required property Notification notification

    width: parent.width
    height: item.height
    color: "transparent"

    opacity: 0
    x: width

    signal expired

    RectangularShadow {
        anchors.fill: parent
        radius: item.radius
        color: "black"
        opacity: 0.5
        offset.y: 2
        blur: 10
        z: -1
    }

    NotificationItem {
        id: item
        notification: popup.notification
    }

    Component.onCompleted: {
        popup.opacity = 1;
        popup.x = 0;
    }

    Timer {
        interval: 3000
        running: true
        onTriggered: popup.expired()
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    Behavior on x {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
}
