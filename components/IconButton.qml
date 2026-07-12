import QtQuick
import QtQuick.Controls
import "../utils"

Button {
    id: root

    property alias iconText: icon.icon
    property alias color: background.color

    property int size: 40
    property int iconSize: 20

    implicitWidth: size
    implicitHeight: size

    focusPolicy: Qt.NoFocus

    Icon {
        id: icon
        anchors.centerIn: parent
        color: Colors.md3.on_background
        size: root.iconSize
    }

    background: Rectangle {
        id: background
        anchors.fill: parent
        radius: width / 2
        color: {
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
}
