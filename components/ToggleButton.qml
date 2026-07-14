import QtQuick
import QtQuick.Controls
import "../utils"

Button {
    id: root

    property alias title: label.text
    property alias subtitle: sublabel.text
    property alias iconText: icon.icon
    property alias iconSize: icon.size

    readonly property int margin: 14

    checkable: true
    implicitHeight: 52

    focusPolicy: Qt.NoFocus

    background: Rectangle {
        anchors.fill: parent
        radius: Theme.radiusLarge
        color: {
            if (root.checked) {
                if (root.pressed)
                    return Qt.lighter(Theme.accent, Theme.accentPressedMultiplier);
                if (root.hovered)
                    return Qt.lighter(Theme.accent, Theme.accentHoverMultiplier);
                return Theme.accent;
            }

            if (root.pressed)
                return Qt.lighter(Theme.overlay, Theme.pressedMultiplier);
            if (root.hovered)
                return Qt.lighter(Theme.overlay, Theme.hoverMultiplier);
            return Theme.overlay;
        }

        Behavior on color {
            ColorAnimation {
                duration: Theme.animationDuration
                easing.type: Theme.animationEasing
            }
        }
    }

    Icon {
        id: icon
        color: {
            if (root.checked)
                return Theme.textAccent;
            return Theme.text;
        }
        size: root.iconSize
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: root.margin
    }

    Column {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: root.margin * 2 + root.iconSize

        Text {
            id: label
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
            color: {
                if (root.checked)
                    return Theme.textAccent;
                return Theme.text;
            }
            elide: Text.ElideRight
        }
        Text {
            id: sublabel
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
