import QtQuick

Rectangle {
    id: popup

    required property var notification

    width: parent.width
    height: item.height
    color: "transparent"

    opacity: 0
    x: width

    signal expired

    NotificationItem {
        id: item
        notification: popup.notification

        onClosed: {
            popup.expired();
        }
    }

    Component.onCompleted: {
        popup.opacity = 1
        popup.x = 0
    }

    Timer {
        interval: 3000
        running: true
        onTriggered: {
            item.closing = true;
        }
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
