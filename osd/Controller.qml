pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import "." as Osd
import "../utils"

Singleton {
    id: root

    enum ContentType {
        Text,
        Progress
    }

    property bool overlayLoaded: false
    property bool overlayVisible: false

    property string icon: ""
    property color iconColor: "#e3e3e3"
    property string text: ""
    property real value: 0
    property int contentType: Osd.Controller.ContentType.Text

    function showOverlay(data) {
        contentType = data.contentType;
        icon = data.icon;
        iconColor = data.iconColor ?? "#e3e3e3";
        text = data.text ?? "";
        value = data.value ?? 0;

        overlayLoaded = true;
        overlayVisible = true;

        timer.restart();
    }

    function closeOverlay() {
        overlayVisible = false;
    }

    function showMedia(player, icon) {
        showOverlay({
            contentType: Osd.Controller.ContentType.Text,
            icon,
            text: player.trackArtist ? `${player.trackArtist} - ${player.trackTitle}` : player.trackTitle
        });
    }

    function showVolume(node) {
        showOverlay({
            contentType: Osd.Controller.ContentType.Progress,
            icon: Audio.icon(node),
            value: node.audio.muted ? 0 : node.audio.volume
        });
    }

    function showBrightness() {
        showOverlay({
            contentType: Osd.Controller.ContentType.Progress,
            icon: "",
            value: Brightness.value
        });
    }

    function showMediaAfterTrackChange(player, icon) {
        // Get the new information then immediately disconnect
        function handler() {
            player.postTrackChanged.disconnect(handler);
            showMedia(player, icon);
        }

        player.postTrackChanged.connect(handler);
    }

    IpcHandler {
        target: "osd"

        function media(command: string) {
            const player = Players.players[0];

            if (!player)
                return;

            switch (command) {
            case "togglePlaying":
                player.togglePlaying();
                const playing = player.playbackState === MprisPlaybackState.Playing;
                root.showMedia(player, playing ? "" : "");
                break;
            case "next":
                root.showMediaAfterTrackChange(player, "");
                player.next();
                break;
            case "previous":
                root.showMediaAfterTrackChange(player, "");
                player.previous();
                break;
            case "raiseVolume":
                player.volume = Math.min(player.volume + 0.05, 1);
                root.showOverlay({
                    contentType: Osd.Controller.ContentType.Progress,
                    icon: "",
                    value: player.volume
                });
                break;
            case "lowerVolume":
                player.volume = Math.max(player.volume - 0.05, 0);
                root.showOverlay({
                    contentType: Osd.Controller.ContentType.Progress,
                    icon: "",
                    value: player.volume
                });
                break;
            }
        }

        function brightness(command: string) {
            if (!Brightness.backlight)
                return;

            switch (command) {
            case "raise":
                Brightness.setBrightness(Math.min(Brightness.value + 0.05, 1));
                root.showBrightness();
                break;
            case "lower":
                Brightness.setBrightness(Math.max(Brightness.value - 0.05, 0));
                root.showBrightness();
                break;
            }
        }

        function outputVolume(command: string) {
            switch (command) {
            case "raise":
                Audio.defaultSink.audio.volume = Math.min(Audio.defaultSink.audio.volume + 0.05, 1);
                root.showVolume(Audio.defaultSink);
                break;
            case "lower":
                Audio.defaultSink.audio.volume = Math.max(Audio.defaultSink.audio.volume - 0.05, 0);
                root.showVolume(Audio.defaultSink);
                break;
            case "toggleMute":
                Audio.defaultSink.audio.muted = !Audio.defaultSink.audio.muted;
                root.showVolume(Audio.defaultSink);
                break;
            }
        }

        function inputVolume(command: string) {
            switch (command) {
            case "raise":
                Audio.defaultSource.audio.volume = Math.min(Audio.defaultSource.audio.volume + 0.05, 1);
                root.showVolume(Audio.defaultSource);
                break;
            case "lower":
                Audio.defaultSource.audio.volume = Math.max(Audio.defaultSource.audio.volume - 0.05, 0);
                root.showVolume(Audio.defaultSource);
                break;
            case "toggleMute":
                Audio.defaultSource.audio.muted = !Audio.defaultSource.audio.muted;
                root.showVolume(Audio.defaultSource);
                break;
            }
        }

        function capsLock() {
            capsLockProcess.running = true;
        }
    }

    LazyLoader {
        active: root.overlayLoaded

        Osd.Overlay {
            icon: root.icon
            iconColor: root.iconColor
            text: root.text
            value: root.value
            contentType: root.contentType
            controller: root
        }
    }

    Timer {
        id: timer
        interval: 1000
        onTriggered: root.closeOverlay()
    }

    Process {
        id: capsLockProcess
        command: ["hyprctl", "-j", "devices"]

        stdout: StdioCollector {
            onStreamFinished: {
                const devices = JSON.parse(this.text);
                const mainKeyboard = devices.keyboards.find(kb => {
                    return kb.main == true;
                });
                const capsLock = mainKeyboard?.capsLock ?? false;

                root.showOverlay({
                    contentType: Osd.Controller.ContentType.Text,
                    icon: "",
                    iconColor: capsLock ? "#e3e3e3" : Qt.alpha("#e3e3e3", 0.5),
                    text: "Caps Lock " + (capsLock ? "On" : "Off")
                });
            }
        }
    }

    function init() {
    }
}
