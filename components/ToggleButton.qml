import QtQuick
import QtQuick.Controls
import "../utils"

Button {
    id: button

    property alias title: label.text
    property alias subtitle: sublabel.text
    property alias iconText: icon.icon
    property alias iconSize: icon.size

    property int margin: 14

    checkable: true
    implicitHeight: 52

    background: Rectangle {
        anchors.fill: parent
        radius: 20
        color: {
            if (button.checked) {
                if (button.pressed)
                    return Qt.lighter(Colors.md3.primary, 1.2);
                if (button.hovered)
                    return Qt.lighter(Colors.md3.primary, 1.1);
                return Colors.md3.primary;
            }

            if (button.pressed)
                return Qt.lighter(Colors.md3.background, 3);
            if (button.hovered)
                return Qt.lighter(Colors.md3.background, 2.5);
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
            if (button.checked)
                return Colors.md3.on_primary;
            return Colors.md3.on_background;
        }
        size: button.iconSize
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: button.margin
    }

    Column {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: button.margin * 2 + button.iconSize

        Text {
            id: label
            font.family: "NotoSans Nerd Font Propo"
            font.pixelSize: 14
            color: {
                if (button.checked)
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
                if (button.checked)
                    return Colors.md3.on_primary;
                return Colors.md3.on_background;
            }
            elide: Text.ElideRight
        }
    }
}
