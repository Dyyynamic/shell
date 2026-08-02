pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import "../utils"

PanelWindow {
    id: root
    WlrLayershell.namespace: "qs-capture"

    signal regionSelected(rect region)

    required property var controller

    property int startX: 0
    property int startY: 0
    property int endX: 0
    property int endY: 0

    readonly property int rawWidth: Math.abs(endX - startX)
    readonly property int rawHeight: Math.abs(endY - startY)
    readonly property int size: Math.max(rawWidth, rawHeight)

    property bool shiftHeld: false
    property bool inputEnabled: true
    property bool cancelled: false

    readonly property int left: {
        if (shiftHeld)
            return endX < startX ? startX - size : startX;
        return Math.min(startX, endX);
    }
    readonly property int top: {
        if (shiftHeld)
            return endY < startY ? startY - size : startY;
        return Math.min(startY, endY);
    }
    readonly property int right: {
        if (shiftHeld)
            return endX < startX ? startX : startX + size;
        return Math.max(startX, endX);
    }
    readonly property int bottom: {
        if (shiftHeld)
            return endY < startY ? startY : startY + size;
        return Math.max(startY, endY);
    }

    readonly property int w: right - left
    readonly property int h: bottom - top

    property bool isSelecting: false
    property bool hasSelection: false

    property real dimOpacity: root.hasSelection ? 0.2 : 0.4

    Behavior on dimOpacity {
        NumberAnimation {
            duration: Theme.durationMedium
            easing.type: Theme.easingStandard
        }
    }

    onDimOpacityChanged: canvas.requestPaint()

    exclusionMode: ExclusionMode.Ignore
    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }
    color: "transparent"
    WlrLayershell.keyboardFocus: inputEnabled ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    // Make click-through if input is disabled
    mask: inputEnabled ? null : maskRegion

    Region {
        id: maskRegion
    }

    NumberAnimation {
        id: enterAnimation
        target: wrapper
        property: "opacity"
        from: 0
        to: 1
        duration: Theme.durationMedium
        easing.type: Theme.easingStandard

        // Run immediately
        running: root.controller.overlayVisible
    }

    NumberAnimation {
        id: exitAnimation
        target: wrapper
        property: "opacity"
        from: 1
        to: 0
        duration: Theme.durationMedium
        easing.type: Theme.easingStandard

        // Fade out before unloading
        running: !root.controller.overlayVisible
        onFinished: root.controller.overlayLoaded = false
    }

    contentItem {
        focus: true
        Keys.onEscapePressed: {
            root.cancelled = true;
            root.controller.closeOverlay();
        }
        Keys.onPressed: event => {
            if (event.key === Qt.Key_Shift)
                root.shiftHeld = true;
        }
        Keys.onReleased: event => {
            if (event.key === Qt.Key_Shift)
                root.shiftHeld = false;
        }
    }

    Item {
        id: wrapper
        anchors.fill: parent

        Canvas {
            id: canvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();

                // Background dim
                ctx.fillStyle = Qt.rgba(0, 0, 0, root.dimOpacity);
                ctx.fillRect(0, 0, root.width, root.height);

                if (!root.hasSelection && !root.isSelecting)
                    return;

                // Clear selected region
                ctx.clearRect(root.left, root.top, root.w, root.h);

                // Outline
                ctx.strokeStyle = Qt.alpha("#e3e3e3", 0.5);
                ctx.lineWidth = 2;
                ctx.strokeRect(root.left - 1, root.top - 1, root.w + 2, root.h + 2);
            }
        }

        Text {
            opacity: root.isSelecting ? 1 : 0
            x: root.right + Theme.spacingSmall
            y: root.bottom + Theme.spacingSmall
            text: root.w + "x" + root.h
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeMedium
            color: Qt.alpha("#e3e3e3", 0.5)

            Behavior on opacity {
                NumberAnimation {
                    duration: root.hasSelection ? Theme.durationMedium : 0
                    easing: Theme.easingStandard
                }
            }
        }
    }

    MouseArea {
        enabled: root.inputEnabled

        anchors.fill: parent
        cursorShape: Qt.CrossCursor

        onPressed: event => {
            root.isSelecting = true;

            root.startX = Math.ceil(event.x);
            root.startY = Math.ceil(event.y);
            root.endX = Math.ceil(event.x);
            root.endY = Math.ceil(event.y);
        }

        onPositionChanged: event => {
            root.endX = Math.ceil(event.x);
            root.endY = Math.ceil(event.y);
        }

        onReleased: () => {
            if (root.cancelled)
                return;

            root.hasSelection = true;
            root.isSelecting = false;

            // Add screen offset
            const x = root.left + root.screen.x;
            const y = root.top + root.screen.y;
            const w = root.w;
            const h = root.h;
            root.regionSelected(Qt.rect(x, y, w, h));
        }
    }

    onEndXChanged: canvas.requestPaint()
    onEndYChanged: canvas.requestPaint()
}
