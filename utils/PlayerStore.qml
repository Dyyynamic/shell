pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Mpris
import QtQml
import QtQml.Models

Singleton {
    id: root

    property MprisPlayer lastPlayedPlayer: null

    readonly property var players: Mpris.players
    readonly property int playerCount: Mpris.players.values.length
    readonly property bool hasActivePlayer: playerCount > 0 && lastPlayedPlayer

    function updateLastPlayedPlayer(player: MprisPlayer) {
        if (player.playbackState === MprisPlaybackState.Playing) {
            root.lastPlayedPlayer = player;
        }
    }

    Instantiator {
        model: Mpris.players

        delegate: Connections {
            required property var modelData

            target: modelData

            Component.onCompleted: {
                root.updateLastPlayedPlayer(modelData);
            }

            function onPlaybackStateChanged() {
                root.updateLastPlayedPlayer(modelData);
            }
        }
    }
}
