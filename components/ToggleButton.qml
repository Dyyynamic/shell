import QtQuick
import "../utils"

Rectangle {
    id: button

    property alias icon: icon.icon
    property alias text: label.text
    property alias subtext: sublabel.text
    property alias iconSize: icon.size
    property bool checked: false
    property bool hovered: false

    property int margin: 14

    signal clicked

    height: 52
    radius: 20
    color: {
        if (button.checked) {
            Colors.md3.primary;
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
        color: button.checked ? Colors.md3.on_primary : Colors.md3.on_background
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
            text: ""
            font.pixelSize: 14
            color: button.checked ? Colors.md3.on_primary : Colors.md3.on_background
            elide: Text.ElideRight
        }
        Text {
            id: sublabel
            text: ""
            font.pixelSize: 12
            color: button.checked ? Colors.md3.on_primary : Colors.md3.on_background
            elide: Text.ElideRight
        }
    }


    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            button.hovered = true;
        }
        onExited: {
            button.hovered = false;
        }
        onClicked: button.clicked()
    }
}
