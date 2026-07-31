import Quickshell.Widgets

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

    signal toggled
    signal clicked

    implicitHeight: 52

    Button {
        id: panelButton

        anchors.fill: parent

        checkable: root.checkable && !root.checkableIcon
        checked: root.checked && !root.checkableIcon

        onClicked: {
            root.clicked()

            if (!root.checkableIcon)
                root.toggled()
        }

        background: Rectangle {
            anchors.fill: parent
            radius: Theme.radiusLarge

            color: {
                if (panelButton.checked) {
                    if (iconButton.enabled && iconButton.hovered)
                        return Theme.accent;
                    if (panelButton.pressed)
                        return Theme.colorMix(Theme.accent, Theme.textAccent, Theme.accentPressIntensity);
                    if (panelButton.hovered)
                        return Theme.colorMix(Theme.accent, Theme.textAccent, Theme.accentHoverIntensity);
                    return Theme.accent;
                }

                if (iconButton.enabled && iconButton.hovered)
                    return Theme.overlay;
                if (panelButton.pressed)
                    return Theme.colorMix(Theme.overlay, Theme.text, Theme.pressIntensity);
                if (panelButton.hovered)
                    return Theme.colorMix(Theme.overlay, Theme.text, Theme.hoverIntensity);
                return Theme.overlay;
            }

            Behavior on color {
                ColorAnimation {
                    duration: Theme.durationFast
                    easing.type: Theme.easingStandard
                }
            }
        }

        WrapperItem {
            margin: Theme.spacingTiny
            anchors.fill: parent

            RowLayout {
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
                                    return Theme.colorMix(Theme.accent, Theme.textAccent, Theme.accentPressIntensity);
                                if (iconButton.hovered)
                                    return Theme.colorMix(Theme.accent, Theme.textAccent, Theme.accentHoverIntensity);
                                return Theme.accent;
                            }

                            if (iconButton.pressed)
                                return Theme.colorMix(Theme.overlayHigh, Theme.text, Theme.pressIntensity);
                            if (iconButton.hovered)
                                return Theme.colorMix(Theme.overlayHigh, Theme.text, Theme.hoverIntensity);
                            return Theme.overlayHigh;
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
                                return Theme.textAccent;
                            return Theme.textVariant;
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
                                return Theme.textAccent;
                            return Theme.text;
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
                                return Theme.textAccent;
                            return Theme.textVariant;
                        }
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }
}
