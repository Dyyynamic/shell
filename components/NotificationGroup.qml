import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property var notifs

    property bool expanded: false

    width: parent.width
    implicitHeight: layout.implicitHeight

    function dismissGroup() {
        for (let notif of root.notifs.notifications) {
            notif.dismiss()
        }
    }

    ColumnLayout {
        id: layout
        spacing: 2
        width: parent.width

        // Latest
        NotificationItem {
            notification: root.notifs.latest
            Layout.fillWidth: true
            showExpandButton: root.notifs.notifications.length > 1
            expanded: root.expanded
            expandLabel: root.notifs.notifications.length

            bottomLeftRadius: {
                if (root.notifs.notifications.length > 1 && root.expanded)
                    return 0;
            }
            bottomRightRadius: {
                if (root.notifs.notifications.length > 1 && root.expanded)
                    return 0;
            }

            onExpandClicked: root.expanded = !root.expanded
            onDismissed: {
                if (root.expanded) {
                    root.notifs.latest.dismiss()
                } else {
                    root.dismissGroup()
                }
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
                    required property int index
                    required property var modelData
                    notification: modelData

                    topLeftRadius: 0
                    topRightRadius: 0
                    bottomLeftRadius: {
                        if (index < root.notifs.notifications.length - 2)
                            0;
                    }
                    bottomRightRadius: {
                        if (index < root.notifs.notifications.length - 2)
                            0;
                    }

                    onDismissed: {
                        modelData.dismiss()
                    }
                }
            }
        }
    }
}
