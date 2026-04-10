import QtQuick
import QtQuick.Layouts
import "../utils"

Rectangle {
    id: button

    property alias icon: icon.icon
    property alias label: label.text
    property bool hovered: false
    property bool pressed: false
    property var onClicked: undefined

    property int iconSize: 12

    width: content.width + 16
    height: 20
    radius: height / 2
    color: {
        if (button.pressed)
            return Qt.lighter(Colors.md3.background, 3);
        if (button.hovered)
            return Qt.lighter(Colors.md3.background, 2.5);
        return Qt.lighter(Colors.md3.background, 2);
    }

    RowLayout {
        id: content
        anchors.centerIn: parent
        spacing: 4

        Text {
            id: label
            text: label
            color: Colors.md3.on_background
        }

        Icon {
            id: icon
            color: Colors.md3.on_background
            size: button.iconSize
        }
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
