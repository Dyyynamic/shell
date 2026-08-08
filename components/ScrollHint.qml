import QtQuick
import "../utils"

Rectangle {
    id: root

    required property var listView
    property string direction: "bottom"

    anchors {
        left: parent.left
        right: parent.right
        top: direction === "top" ? parent.top : undefined
        bottom: direction === "bottom" ? parent.bottom : undefined
    }

    height: 24

    opacity: {
        if (listView.contentHeight <= listView.height)
            return 0

        if (direction === "bottom")
            return listView.atYEnd ? 0 : 1

        return listView.atYBeginning ? 0 : 1
    }

    Behavior on opacity {
        NumberAnimation {
            duration: Theme.durationFast
            easing: Theme.easingStandard
        }
    }

    gradient: Gradient {
        GradientStop {
            position: root.direction === "bottom" ? 0 : 1
            color: "transparent"
        }

        GradientStop {
            position: root.direction === "bottom" ? 1 : 0
            color: Qt.alpha("black", 0.15)
        }
    }
}
