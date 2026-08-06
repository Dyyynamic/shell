pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    function formatTime(seconds) {
        seconds = Math.floor(seconds);

        const hours = Math.floor(seconds / 3600);
        const minutes = Math.floor((seconds % 3600) / 60);
        const remainingSeconds = seconds % 60;

        const formattedMinutes = minutes.toString().padStart(2, "0");
        const formattedSeconds = remainingSeconds.toString().padStart(2, "0");

        if (hours > 0) {
            return `${hours}:${formattedMinutes}:${formattedSeconds}`;
        }

        return `${minutes}:${formattedSeconds}`;
    }

    function capitalize(str) {
        return str.charAt(0).toUpperCase() + str.slice(1);
    }
}
