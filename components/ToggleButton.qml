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
        radius: 20
        color: {
            if (root.checked) {
                if (root.pressed)
                    return Qt.lighter(Colors.md3.primary, 1.2);
                if (root.hovered)
                    return Qt.lighter(Colors.md3.primary, 1.1);
                return Colors.md3.primary;
            }

            if (root.pressed)
                return Qt.lighter(Colors.md3.background, 3.5);
            if (root.hovered)
                return Qt.lighter(Colors.md3.background, 2.75);
            return Qt.lighter(Colors.md3.background, 2);
        }

        Behavior on color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
    }

    Icon {
        id: icon
        color: {
            if (root.checked)
                return Colors.md3.on_primary;
            return Colors.md3.on_background;
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
            font.family: "NotoSans Nerd Font Propo"
            font.pixelSize: 14
            color: {
                if (root.checked)
                    return Colors.md3.on_primary;
                return Colors.md3.on_background;
            }
            elide: Text.ElideRight
        }
        Text {
            id: sublabel
            font.family: "NotoSans Nerd Font Propo"
            font.pixelSize: 12
            color: {
                if (root.checked)
                    return Colors.md3.on_primary;
                return Colors.md3.on_background;
            }
            elide: Text.ElideRight
        }
    }
}
