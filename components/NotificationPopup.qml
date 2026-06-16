import QtQuick

Rectangle {
    id: popup

    required property var notification

    property bool closing: false
    opacity: closing ? 0 : 1
    width: parent.width
    height: item.height
    color: "transparent"

    signal expired

    NotificationItem {
        id: item
        notification: popup.notification

        onDismissed: {
            popup.closing = true;
        }
    }

    Timer {
        interval: 3000
        running: true
        onTriggered: {
            popup.closing = true;
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
            onRunningChanged: {
                if (!running) {
                    popup.expired();
                }
            }
        }
    }
}
