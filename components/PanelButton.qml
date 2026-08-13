import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "." as Components
import "../utils"

Item {
    id: root

    property string icon: ""
    property string title: ""
    property string subtitle: ""

    property bool checkable: false
    property bool checked: false

    property bool checkableIcon: false
    property bool iconOnly: false

    property alias hovered: panelButton.hovered
    property alias pressed: panelButton.pressed

    signal toggled
    signal clicked

    implicitHeight: 52

    Button {
        id: panelButton

        anchors.fill: parent

        checkable: root.checkable && !root.checkableIcon
        checked: root.checked && !root.checkableIcon

        onClicked: {
            root.clicked();

            if (!root.checkableIcon)
                root.toggled();
        }

        background: Rectangle {
            anchors.fill: parent
            radius: Theme.radiusLarge

            color: {
                if (panelButton.checked) {
                    if (iconButton.enabled && iconButton.hovered)
                        return Colors.md3.primary_fixed_dim;
                    if (panelButton.pressed)
                        return Theme.colorMix(Colors.md3.primary_fixed_dim, Colors.md3.on_primary_fixed, Theme.pressIntensity);
                    if (panelButton.hovered)
                        return Theme.colorMix(Colors.md3.primary_fixed_dim, Colors.md3.on_primary_fixed, Theme.hoverIntensity);
                    return Colors.md3.primary_fixed_dim;
                }

                if (iconButton.enabled && iconButton.hovered)
                    return Colors.md3.surface_container_high;
                if (panelButton.pressed)
                    return Theme.colorMix(Colors.md3.surface_container_high, Colors.md3.on_surface, Theme.pressIntensity);
                if (panelButton.hovered)
                    return Theme.colorMix(Colors.md3.surface_container_high, Colors.md3.on_surface, Theme.hoverIntensity);
                return Colors.md3.surface_container_high;
            }

            Behavior on color {
                ColorAnimation {
                    duration: Theme.durationFast
                    easing.type: Theme.easingStandard
                }
            }
        }

        Item {
            anchors.fill: parent
            anchors.margins: Theme.spacingTiny

            RowLayout {
                anchors.fill: parent
                spacing: Theme.spacingTiny

                Button {
                    id: iconButton
                    Layout.alignment: root.iconOnly ? Qt.AlignHCenter : Qt.AlignLeft

                    implicitHeight: 44
                    implicitWidth: 44

                    enabled: root.checkableIcon

                    checkable: root.checkable
                    checked: root.checked

                    onClicked: root.toggled()

                    background: Rectangle {
                        anchors.fill: parent
                        radius: Theme.radiusMedium

                        color: {
                            if (!enabled)
                                return "transparent";

                            if (iconButton.checked) {
                                if (iconButton.pressed)
                                    return Theme.colorMix(Colors.md3.primary_fixed_dim, Colors.md3.on_primary_fixed, Theme.pressIntensity);
                                if (iconButton.hovered)
                                    return Theme.colorMix(Colors.md3.primary_fixed_dim, Colors.md3.on_primary_fixed, Theme.hoverIntensity);
                                return Colors.md3.primary_fixed_dim;
                            }

                            if (iconButton.pressed)
                                return Theme.colorMix(Colors.md3.surface_container_highest, Colors.md3.on_surface, Theme.pressIntensity);
                            if (iconButton.hovered)
                                return Theme.colorMix(Colors.md3.surface_container_highest, Colors.md3.on_surface, Theme.hoverIntensity);
                            return Colors.md3.surface_container_highest;
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: Theme.durationFast
                                easing.type: Theme.easingStandard
                            }
                        }
                    }

                    Components.Icon {
                        anchors.centerIn: parent

                        icon: root.icon
                        size: 24

                        color: {
                            if (root.checked)
                                return Colors.md3.on_primary_fixed;
                            return Colors.md3.on_surface_variant;
                        }
                    }
                }

                ColumnLayout {
                    spacing: 0
                    visible: !root.iconOnly

                    Text {
                        id: label
                        Layout.fillWidth: true

                        text: root.title

                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        font.weight: Font.Medium
                        color: {
                            if (root.checked && !root.checkableIcon)
                                return Colors.md3.on_primary_fixed;
                            return Colors.md3.on_surface;
                        }
                        elide: Text.ElideRight
                    }

                    Text {
                        id: sublabel
                        Layout.fillWidth: true

                        text: root.subtitle

                        visible: root.subtitle !== ""
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeTiny
                        color: {
                            if (root.checked && !root.checkableIcon)
                                return Colors.md3.on_primary_fixed;
                            return Colors.md3.on_surface_variant;
                        }
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }
}
