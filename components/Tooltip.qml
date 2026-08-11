import QtQuick
import QtQuick.Controls
import "../utils"

Popup {
    id: root

    property Item target
    property Item anchor: target
    property bool showWhilePressed: false

    property string text: ""
    property string side: "bottom" // or "top"
    property int gap: Theme.spacingTiny
    property int delay: 1000

    function updatePosition() {
        if (!anchor || !root.parent)
            return;

        const position = anchor.mapToItem(root.parent, 0, 0);

        root.x = position.x + (anchor.width - root.width) / 2;

        if (side === "bottom")
            root.y = position.y + anchor.height + gap;
        if (side === "top")
            root.y = position.y - root.height - root.gap;
    }

    Component.onCompleted: updatePosition()

    closePolicy: Popup.NoAutoClose

    opacity: 0
    visible: opacity > 0

    Behavior on opacity {
        NumberAnimation {
            duration: Theme.durationFast
            easing: Theme.easingStandard
        }
    }

    topPadding: Theme.spacingTiny
    bottomPadding: Theme.spacingTiny
    leftPadding: Theme.spacingSmall
    rightPadding: Theme.spacingSmall

    background: Rectangle {
        color: Colors.md3.inverse_surface
        radius: Theme.radiusTiny
    }

    contentItem: Text {
        text: root.text
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
        color: Colors.md3.inverse_on_surface
    }

    Connections {
        target: root.target

        function onHoveredChanged() {
            if (root.target.hovered) {
                showTimer.restart();
            } else {
                showTimer.stop();

                if (!root.target.pressed)
                    root.opacity = 0;
            }
        }

        function onPressedChanged() {
            if (root.target.pressed)
                root.opacity = root.showWhilePressed ? 1 : 0;
            else if (!root.target.hovered)
                root.opacity = 0;
        }
    }

    Connections {
        target: root.anchor

        function onXChanged() {
            root.updatePosition();
        }

        function onYChanged() {
            root.updatePosition();
        }

        function onWidthChanged() {
            root.updatePosition();
        }

        function onHeightChanged() {
            root.updatePosition();
        }
    }

    Timer {
        id: showTimer
        interval: root.delay
        onTriggered: root.opacity = 1
    }
}
