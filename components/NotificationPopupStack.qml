import Quickshell
import QtQuick.Layouts
import QtQuick
import "../utils"

PanelWindow {
    id: root

    required property var bar

    property var margin: 10

    anchors {
        top: true
        bottom: true
        right: true
    }
    margins.top: bar.height + margin
    margins.bottom: margin
    margins.right: margin
    exclusionMode: ExclusionMode.Ignore
    implicitWidth: 400
    color: "transparent"
    screen: bar.screen

    mask: Region {}

    function removePopup(id) {
        for (let i = 0; i < popupModel.count; i++) {
            if (popupModel.get(i).notification.id === id) {
                popupModel.remove(i);
                break;
            }
        }
    }

    Connections {
        target: NotificationStore

        function onNotificationReceived(notification) {
            popupModel.append({
                notification: notification
            });
        }
    }

    ListModel {
        id: popupModel
    }

    ListView {
        id: listView
        anchors.fill: parent
        interactive: false
        model: popupModel

        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 10

        delegate: NotificationPopup {
            required property var modelData
            notification: modelData

            onExpired: {
                root.removePopup(notification.id);
            }
        }
    }
}
