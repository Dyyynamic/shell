import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "../utils"
import "../components" as Components

Indicator {
    id: root

    margin: 12
    clickable: true

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.spacingSmall

        Components.Icon {
            visible: Notifications.doNotDisturb || Notifications.notifications.values.length > 0
            icon: Notifications.doNotDisturb ? "󰂠" : "󱅫"
            color: root.textColor
        }

        Components.Icon {
            icon: Wifi.icon(Wifi.connectedNetwork)
            color: root.textColor
        }

        Components.Icon {
            icon: Audio.icon(Audio.defaultSink)
            color: root.textColor
        }

        ClippingRectangle {
            visible: Battery.available

            implicitWidth: Battery.charging ? 34 : 26
            implicitHeight: 15

            color: Qt.alpha(root.textColor, 0.65)
            radius: height / 2

            Rectangle {
                height: parent.height
                width: Battery.percentage * parent.width
                color: root.textColor
            }

            RowLayout {
                anchors.centerIn: parent
                spacing: 0

                Components.Icon {
                    visible: Battery.charging
                    icon: "󱐋"
                    size: 14
                    color: root.inverseTextColor
                }

                Text {
                    rightPadding: Battery.charging ? 4 : 0
                    horizontalAlignment: Text.AlignHCenter
                    text: Math.round(Battery.percentage * 100)
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                    font.weight: Font.Bold
                    color: root.inverseTextColor
                }
            }
        }
    }
}
