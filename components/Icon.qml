import QtQuick
import "../utils"

Item {
    id: root

    property alias icon: icon.text
    property alias color: icon.color
    property int size: 20

    width: size
    height: size

    Text {
        id: icon
        anchors.centerIn: parent

        font.family: Theme.fontFamily
        font.pixelSize: root.size * 0.8
        color: Colors.md3.on_surface
    }
}
