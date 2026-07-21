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

    function open() {
        root.isTransitioning = true;
        root.isOpen = true;
        loader.item.enterAnimation.start();
    }

    function close() {
        if (!root.isOpen)
            return;

        root.isTransitioning = true;
        root.isOpen = false;
        loader.item.exitAnimation.start();
    }

    function toggle() {
        root.isOpen ? close() : open();
    }

    function transitionFinished() {
        root.isTransitioning = false;
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
    }

    function init() {
    }
}
