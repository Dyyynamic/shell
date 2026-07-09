import Quickshell
import QtQuick.Layouts
import QtQuick
import "../utils"

PanelWindow {
    id: root

    required property var bar

    property int margin: 10

    anchors {
        top: true
        right: true
        bottom: true
    }
    margins.top: bar.height
    exclusionMode: ExclusionMode.Ignore
    implicitHeight: listView.contentHeight + margin * 2
    implicitWidth: 400
    color: "transparent"
    screen: bar.screen

    // Make everything click-through except the list-view, which scales
    // according to its content height
    mask: Region {
        item: listView
    }

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
            if (NotificationStore.doNotDisturb) return;

            popupModel.append({
                notification: notification
            });
        }

        function onNotificationClosed(notification) {
            removePopup(notification.id);
        }
    }

    ListModel {
        id: popupModel
    }

    Item {
        anchors.fill: parent
        anchors.rightMargin: root.margin
        anchors.topMargin: root.margin
        anchors.bottomMargin: root.margin

        ListView {
            id: listView
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            height: contentHeight
            interactive: false
            model: popupModel

            spacing: 10

            displaced: Transition {
                NumberAnimation {
                    properties: "y"
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            remove: Transition {
                NumberAnimation {
                    properties: "opacity"
                    to: 0
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            delegate: NotificationPopup {
                required property var modelData
                notification: modelData

                onExpired: root.removePopup(notification.id)
            }
        }
    }
}
