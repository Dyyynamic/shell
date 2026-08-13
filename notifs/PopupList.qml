pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import "../utils"

PanelWindow {
    id: root
    WlrLayershell.namespace: "qs-notifications"

    screen: Screens.main

    anchors {
        top: true
        right: true
        bottom: true
    }
    exclusionMode: ExclusionMode.Normal
    implicitWidth: 400 + Theme.spacingSmall * 2
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

    Item {
        anchors.fill: parent
        anchors.margins: Theme.spacingSmall

        ListView {
            id: listView

            anchors.fill: parent

            interactive: false
            model: popupModel

            spacing: Theme.spacingSmall

            add: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: Theme.durationMedium
                        easing.type: Theme.easingStandard
                    }
                    NumberAnimation {
                        property: "x"
                        from: listView.width
                        to: 0
                        duration: Theme.durationMedium
                        easing.type: Theme.easingStandard
                    }
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

            displaced: Transition {
                NumberAnimation {
                    property: "y"
                    duration: Theme.durationMedium
                    easing.type: Theme.easingStandard
                }
            }

            delegate: Notif {
                id: notifItem

                required property var modelData
                notification: modelData

                RectangularShadow {
                    anchors.fill: parent
                    radius: notifItem.radius
                    color: "black"
                    opacity: 0.35
                    offset.y: 2
                    blur: 12
                    z: -1
                }

                Timer {
                    interval: 3000
                    // Pause the timer when hovering the notification
                    running: !notifItem.hovered
                    onTriggered: root.removePopup(notifItem.notification.id)
                }
            }
        }
    }
}
