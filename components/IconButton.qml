import QtQuick
import "../utils"

Rectangle {
    id: button

    property alias icon: icon.icon
    property bool hovered: false
    property bool pressed: false
    property var onClicked: undefined

    property int iconSize: 20

    width: 40
    height: 40
    radius: height / 2
    color: {
        if (button.pressed) {
            Qt.lighter(Colors.md3.background, 3);
        } else {
            if (button.hovered) {
                Qt.lighter(Colors.md3.background, 2.5);
            } else {
                Qt.lighter(Colors.md3.background, 2);
            }
        }
    }

    Icon {
        id: icon
        anchors.centerIn: parent
        color: Colors.md3.on_background
        size: button.iconSize
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: button.hovered = true
        onExited: button.hovered = false
        onPressed: button.pressed = true
        onReleased: button.pressed = false
        onClicked: button.onClicked && button.onClicked()
    }
}
