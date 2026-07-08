import QtQuick
import QtQuick.Controls
import "../utils"

Button {
    id: button

    property alias iconText: icon.icon

    property int size: 40
    property int iconSize: 20

    implicitWidth: size
    implicitHeight: size

    Icon {
        id: icon
        anchors.centerIn: parent
        color: Colors.md3.on_background
        size: button.iconSize
    }

    background: Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: {
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
}
