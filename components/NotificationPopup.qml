import QtQuick
import Quickshell.Services.Notifications

Rectangle {
    id: popup

    required property Notification notification

    width: parent.width
    height: item.height
    color: "transparent"

    opacity: 0
    x: width

    signal exitFinished

    NotificationItem {
        id: item
        notification: popup.notification

        onExitFinished: popup.exitFinished()
    }

    Component.onCompleted: {
        popup.opacity = 1;
        popup.x = 0;
    }

    Timer {
        interval: 3000
        running: true
        onTriggered: item.exit()
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
