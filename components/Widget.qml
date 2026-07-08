import QtQuick
import "../utils"

Rectangle {
    id: widget

    default property alias contentData: content.data

    property bool clickable: false

    signal clicked

    radius: height / 2
    color: {
        if (mouseArea.pressed) {
            Qt.lighter(Colors.md3.background, 3)
        } else {
            if (mouseArea.containsMouse) {
                Qt.lighter(Colors.md3.background, 2.5)
            } else {
                Qt.lighter(Colors.md3.background, 2)
            }
        }
    }

    implicitWidth: content.width + 16
    height: 32

    Row {
        id: content
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        enabled: widget.clickable
        hoverEnabled: true

        onClicked: widget.clicked()
    }

    Behavior on color {
        ColorAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
}
