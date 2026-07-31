import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../utils"
import "../components" as Components

Components.Widget {
    id: root

    ColumnLayout {
        spacing: Theme.spacingSmall

        Item {
            id: content

            readonly property bool hasContent: {
                return Notifications.count > 0 || Players.hasActivePlayer;
            }

            Layout.fillWidth: true
            Layout.fillHeight: true

            Item {
                anchors.fill: parent

                opacity: !content.hasContent ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: Theme.durationMedium
                        easing.type: Theme.easingStandard
                    }
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Theme.spacingSmall

                    Components.Icon {
                        Layout.alignment: Qt.AlignHCenter
                        icon: "󰂚"
                        color: Theme.textDisabled
                        size: 80
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter

                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        text: "No notifications"
                        color: Theme.textDisabled
                    }
                }
            }

            ListView {
                anchors.fill: parent
                spacing: Theme.spacingSmall
                clip: true

                opacity: content.hasContent ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: Theme.durationMedium
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

                remove: Transition {
                    NumberAnimation {
                        property: "opacity"
                        to: 0
                        duration: Theme.durationFast
                        easing.type: Theme.easingStandard
                    }
                }

                header: Players.hasActivePlayer ? playerComponent : null

                Component {
                    id: playerComponent
                    Item {
                        width: parent.width
                        height: player.height + Theme.spacingSmall

                        Components.MediaPlayer {
                            id: player
                        }
                    }
                }

                model: ScriptModel {
                    values: [...Notifications.notifications.values].reverse()
                }

                delegate: Notif {
                    required property var modelData

                    notification: modelData
                    width: ListView.view.width
                }
            }
        }

        RowLayout {
            spacing: Theme.spacingSmall

            WrapperItem {
                margin: Theme.spacingSmall

                Text {
                    text: `${Notifications.count} notification${Notifications.count !== 1 ? 's' : ''}`
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.text
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Components.IconButton {
                iconText: Notifications.doNotDisturb ? "󰂛" : "󰂠"
                size: 32
                implicitWidth: 52
                onClicked: Notifications.toggleDoNotDisturb()
            }

            Components.IconButton {
                iconText: "󰎟"
                enabled: Notifications.count > 0
                size: 32
                iconSize: 24 // Slightly larger because the icon is small
                implicitWidth: 52
                onClicked: Notifications.clear()
            }
        }
    }
}
