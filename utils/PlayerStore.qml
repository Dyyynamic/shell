pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Mpris
import QtQml
import QtQml.Models

Singleton {
    id: root

    property var players: Mpris.players
    property int playerCount: Mpris.players.values.length
    property MprisPlayer lastPlayedPlayer: null
    property bool hasActivePlayer: playerCount > 0 && lastPlayedPlayer

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
