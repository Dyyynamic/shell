import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property var notifs

    property bool expanded: false

    width: parent.width

    ColumnLayout {
        spacing: 2
        width: parent.width

        // Latest
        NotificationItem {
            notification: root.notifs.latest
            Layout.fillWidth: true

            NotifExpandButton {
                visible: root.notifs.notifications.length > 1
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 8
                anchors.topMargin: 8
                icon: root.expanded ? "" : ""
                label: root.notifs.notifications.length - 1
                onClicked: () => root.expanded = !root.expanded
            }
        }

        // Expanded list
        ColumnLayout {
            visible: root.expanded
            spacing: 2
            width: parent.width

            Repeater {
                model: root.notifs.notifications.slice(1)
                delegate: NotificationItem {
                    Layout.fillWidth: true
                    required property var modelData
                    notification: modelData
                }
            }
        }
    }
}
