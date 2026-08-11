pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "." as ControlCenter

Singleton {
    id: root
    property bool isOpen: false
    property bool isTransitioning: false
    property var bar: null

    property var pendingAction: null

    function open() {
        root.isTransitioning = true;
        root.isOpen = true;
    }

    function close() {
        if (!root.isOpen)
            return;

        root.isTransitioning = true;
        root.isOpen = false;
    }

    function closeWithAction(action) {
        if (!root.isOpen && pendingAction)
            return;

        pendingAction = action;
        close();
    }

    function executePendingAction() {
        if (!pendingAction)
            return;

        pendingAction();
        pendingAction = null;
    }

    function toggle() {
        root.isOpen ? close() : open();
    }

    function transitionFinished() {
        root.isTransitioning = false;
    }

    function startColorPicker() {
        colorPicker.running = true;
    }

    IpcHandler {
        target: "controlCenter"

        function open() {
            root.open();
        }

        function close() {
            root.close();
        }

        function toggle() {
            root.toggle();
        }
    }

    LazyLoader {
        id: loader
        active: root.isOpen || root.isTransitioning

        ControlCenter.Overlay {}

        onActiveChanged: {
            if (!active)
                root.executePendingAction();
        }
    }

    Process {
        id: colorPicker
        command: ["hyprpicker"]
    }

    function init() {
    }
}
