pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import "../utils"

PanelWindow {
    id: root
    WlrLayershell.namespace: "qs-notifications"

    readonly property int margin: Theme.spacingSmall

    anchors {
        top: true
        right: true
        bottom: true
    }
    exclusionMode: ExclusionMode.Normal
    implicitWidth: 400 + margin * 2
    color: "transparent"

    // Make everything click-through except notifications
    mask: Region {
        item: listView.contentItem
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
        target: Notifications

        function onNotificationReceived(notification) {
            if (Notifications.doNotDisturb)
                return;

            popupModel.insert(0, {
                notification: notification
            });
        }

        function onNotificationClosed(notification) {
            root.removePopup(notification.id);
        }
    }

    ListModel {
        id: popupModel
    }

    WrapperItem {
        anchors.fill: parent
        margin: root.margin

        ListView {
            id: listView
            interactive: false
            model: popupModel

            spacing: Theme.spacingSmall

            displaced: Transition {
                NumberAnimation {
                    property: "y"
                    duration: Theme.durationMedium
                    easing.type: Theme.easingStandard
                }
            }

            remove: Transition {
                NumberAnimation {
                    property: "opacity"
                    to: 0
                    duration: Theme.durationFast
                    easing.type: Theme.easingStandard
                }
            }

            delegate: Popup {
                required property var modelData
                notification: modelData

                width: listView.width

                onExpired: root.removePopup(notification.id)
            }
        }
    }
}
