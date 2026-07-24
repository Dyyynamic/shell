import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../utils"
import "." as Components

Item {
    id: root

    property alias title: label.text
    property alias subtitle: sublabel.text
    property alias iconText: icon.icon
    property alias iconSize: icon.size
    property bool navButtonVisible: false

    property alias checked: toggleButton.checked

    readonly property int margin: (height - iconSize) / 2

    signal toggled
    signal navButtonClicked

    height: 52

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Button {
            id: toggleButton

            checkable: true
            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked: root.toggled()

            background: Rectangle {
                anchors.fill: parent
                radius: Theme.radiusLarge
                topRightRadius: root.navButtonVisible ? 0 : Theme.radiusLarge
                bottomRightRadius: root.navButtonVisible ? 0 : Theme.radiusLarge

                color: {
                    if (root.checked) {
                        if (toggleButton.pressed)
                            return Theme.colorMix(Theme.accent, Theme.textAccent, Theme.accentPressIntensity);
                        if (toggleButton.hovered)
                            return Theme.colorMix(Theme.accent, Theme.textAccent, Theme.accentHoverIntensity);
                        return Theme.accent;
                    }

                    if (toggleButton.pressed)
                        return Theme.colorMix(Theme.overlay, Theme.text, Theme.pressIntensity);
                    if (toggleButton.hovered)
                        return Theme.colorMix(Theme.overlay, Theme.text, Theme.hoverIntensity);
                    return Theme.overlay;
                }

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.animDurationShort
                        easing.type: Theme.animEasing
                    }
                }
            }

            Rectangle {
                visible: root.navButtonVisible

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right

                height: parent.height - 16
                width: 1

                color: root.checked ? Theme.textAccent : Theme.dividerHigh
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: root.margin
                anchors.rightMargin: root.margin
                spacing: root.margin

                Components.Icon {
                    id: icon
                    color: {
                        if (root.checked)
                            return Theme.textAccent;
                        return Theme.text;
                    }
                    size: root.iconSize
                }

                ColumnLayout {
                    spacing: 0
                    Layout.fillWidth: true

                    Text {
                        id: label
                        Layout.fillWidth: true
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        font.weight: Font.Medium
                        color: {
                            if (root.checked)
                                return Theme.textAccent;
                            return Theme.text;
                        }
                        elide: Text.ElideRight
                    }
                    Text {
                        id: sublabel
                        Layout.fillWidth: true
                        visible: root.subtitle !== ""
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeTiny
                        color: {
                            if (root.checked)
                                return Theme.textAccent;
                            return Theme.text;
                        }
                        elide: Text.ElideRight
                    }
                }
            }
        }

        Button {
            id: navButton

            visible: root.navButtonVisible

            Layout.fillHeight: true
            implicitWidth: 40

            onClicked: root.navButtonClicked()

            background: Rectangle {
                anchors.fill: parent
                radius: Theme.radiusLarge
                topLeftRadius: root.navButtonVisible ? 0 : Theme.radiusLarge
                bottomLeftRadius: root.navButtonVisible ? 0 : Theme.radiusLarge

                color: {
                    if (root.checked) {
                        if (navButton.pressed)
                            return Theme.colorMix(Theme.accent, Theme.textAccent, Theme.accentPressIntensity);
                        if (navButton.hovered)
                            return Theme.colorMix(Theme.accent, Theme.textAccent, Theme.accentHoverIntensity);
                        return Theme.accent;
                    }

                    if (navButton.pressed)
                        return Theme.colorMix(Theme.overlay, Theme.text, Theme.pressIntensity);
                    if (navButton.hovered)
                        return Theme.colorMix(Theme.overlay, Theme.text, Theme.hoverIntensity);
                    return Theme.overlay;
                }

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.animDurationShort
                        easing.type: Theme.animEasing
                    }
                }
            }

            Components.Icon {
                icon: ""
                color: {
                    if (root.checked)
                        return Theme.textAccent;
                    return Theme.text;
                }
                size: 16
                anchors.centerIn: parent
            }
        }
    }
}
