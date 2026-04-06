import QtQuick
import "../utils"

Rectangle {
    id: widget

    default property alias contentData: content.data

    property bool hovered: false
    property bool pressed: false
    property var onClicked: undefined

    radius: height / 2
    color: {
        if (widget.pressed) {
            Qt.lighter(Colors.md3.background, 3)
        } else {
            if (widget.hovered) {
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
        anchors.fill: parent
        hoverEnabled: !!widget.onClicked
        acceptedButtons: widget.onClicked ? Qt.AllButtons : Qt.NoButton
        onEntered: widget.hovered = true
        onExited: widget.hovered = false
        onPressed: widget.pressed = true
        onReleased: widget.pressed = false
        onClicked: widget.onClicked && widget.onClicked()
    }

    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.OutCubic
        }
    }
}
