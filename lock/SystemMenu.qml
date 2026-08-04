import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Widgets
import "../components" as Components
import "../utils"

Item {
    id: root

    required property var powerButton
    property bool show: false

    opacity: show ? 1 : 0
    enabled: root.show

    Behavior on opacity {
        NumberAnimation {
            duration: Theme.durationMedium
            easing.type: Theme.easingStandard
        }
    }

    width: 240
    height: wrapper.height

    anchors {
        bottom: powerButton.top
        right: powerButton.right
        bottomMargin: 16
    }

    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        anchors.fill: parent
        color: Colors.md3.surface_container_high
        radius: Theme.radiusMedium
    }

    WrapperItem {
        id: wrapper

        width: parent.width
        margin: Theme.spacingSmall

        ColumnLayout {
            spacing: 0

            Item {
                Layout.fillWidth: true
                implicitHeight: 40

                Text {
                    text: "System"
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeMedium
                    color: Colors.md3.on_surface
                    font.weight: Font.Bold

                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        right: parent.right
                        leftMargin: Theme.spacingMedium
                        rightMargin: Theme.spacingMedium
                    }
                }
            }

            MenuButton {
                text: "Power Off"
                iconGlyph: ""
                onClicked: powerOffProcess.running = true
            }

            MenuButton {
                text: "Reboot"
                iconGlyph: ""
                onClicked: rebootProcess.running = true
            }

            MenuButton {
                text: "Suspend"
                iconGlyph: ""
                onClicked: suspendProcess.running = true
            }
        }
    }

    component MenuButton: Components.Button {
        implicitHeight: 40
        Layout.fillWidth: true
        radius: Theme.radiusSmall

        fontWeight: Font.Normal
        fontSize: Theme.fontSizeMedium
        textAlignment: Text.AlignLeft
        iconSpacing: Theme.spacingMedium

        backgroundOpacity: hovered ? 1 : 0
    }

    Process {
        id: powerOffProcess
        command: ["systemctl", "poweroff"]
    }

    Process {
        id: rebootProcess
        command: ["systemctl", "reboot"]
    }

    Process {
        id: suspendProcess
        command: ["systemctl", "suspend"]
    }
}
