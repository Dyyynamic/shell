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

        if (hours > 0)
            return `${hours}:${formattedMinutes}:${formattedSeconds}`;

        return `${minutes}:${formattedSeconds}`;
    }

    function formatUptime(seconds) {
        let weeks = Math.floor(seconds / 604800);
        let days = Math.floor((seconds % 604800) / 86400);
        let hours = Math.floor((seconds % 86400) / 3600);
        let minutes = Math.floor((seconds % 3600) / 60);

        if (weeks > 0)
            return `Up ${weeks}w, ${days}d`;
        if (days > 0)
            return `Up ${days}d, ${hours}h`;
        if (hours > 0)
            return `Up ${hours}h, ${minutes}m`;
        return `Up ${minutes}m`;
    }

    function capitalize(str) {
        return str.charAt(0).toUpperCase() + str.slice(1);
    }
}
