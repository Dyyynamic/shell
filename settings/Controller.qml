pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "." as Settings

Singleton {
    id: root
    property bool isOpen: false

    function open() {
        root.isOpen = true;
    }

    function close() {
        if (!root.isOpen)
            return;

        root.isOpen = false;
    }

    function toggle() {
        root.isOpen ? close() : open();
    }

    IpcHandler {
        target: "settings"

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
        active: root.isOpen

        Settings.Window {
            onClosed: root.isOpen = false
        }
    }

    function init() {
    }
}
