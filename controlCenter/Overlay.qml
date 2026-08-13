import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../utils"
import "../notifs" as Notifs
import "." as ControlCenter

PanelWindow {
    id: root
    WlrLayershell.namespace: "qs-control-center"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    color: "transparent"

    MouseArea {
        anchors.fill: parent
        onClicked: ControlCenter.Controller.close()
    }

    Item {
        // Draw everything to a layer so we can animate opacity correctly.
        // To avoid cutting off the shadow, wrap the panel in an Item that
        // fills the parent.
        layer.enabled: true
        anchors.fill: parent

        opacity: ControlCenter.Controller.isOpen ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: {
                    if (ControlCenter.Controller.isOpen)
                        return Theme.durationSlideIn;
                    return Theme.durationMedium;
                }
                easing.type: {
                    if (ControlCenter.Controller.isOpen)
                        return Theme.easingExpressive;
                    return Theme.easingStandard;
                }
                easing.overshoot: {
                    if (ControlCenter.Controller.isOpen)
                        return Theme.overshoot;
                    return 0;
                }
            }
        }

        Item {
            id: panel

            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
                margins: Theme.spacingSmall
            }
            width: 450

            transform: Translate {
                x: ControlCenter.Controller.isOpen ? 0 : panel.width + Theme.spacingSmall

                Behavior on x {
                    NumberAnimation {
                        property: "x"
                        duration: {
                            if (ControlCenter.Controller.isOpen)
                                return Theme.durationSlideIn;
                            return Theme.durationMedium;
                        }
                        easing.type: {
                            if (ControlCenter.Controller.isOpen)
                                return Theme.easingExpressive;
                            return Theme.easingStandard;
                        }
                        easing.overshoot: {
                            if (ControlCenter.Controller.isOpen)
                                return Theme.overshoot;
                            return 0;
                        }

                        // Behavior animations don't emit onFinished, so we use
                        // onRunningChanged instead
                        onRunningChanged: {
                            if (!running)
                                ControlCenter.Controller.isTransitioning = false;
                        }
                    }
                }
            }

            // Prevent clicks inside the panel from closing it
            MouseArea {
                anchors.fill: parent
            }

            RectangularShadow {
                anchors.fill: parent
                radius: background.radius
                color: "black"
                opacity: 0.5
                offset.y: 2
                blur: 24
                z: -1
            }

            Rectangle {
                id: background
                anchors.fill: parent
                radius: Theme.radiusLarge
                color: Colors.md3.background
                border.color: Colors.md3.surface_container_highest
            }

            Item {
                anchors.fill: parent
                anchors.margins: Theme.spacingMedium

                ColumnLayout {
                    anchors.fill: parent

                    spacing: Theme.spacingMedium

                    ControlCenter.Header {
                        Layout.fillWidth: true
                    }

                    ControlCenter.Settings {
                        Layout.fillWidth: true
                    }

                    Notifs.List {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    ControlCenter.Calendar {
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
