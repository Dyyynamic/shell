pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Mpris
import QtQml
import QtQml.Models

Singleton {
    id: root

    // Players sorted by most recently used
    property var players: []

    function touchPlayer(player: MprisPlayer) {
        players = [player, ...players.filter(p => p !== player)];
    }

    function cleanupPlayers() {
        players = players.filter(p => Mpris.players.values.includes(p));
    }

    Connections {
        target: Mpris.players

        // In objectRemovedPre object is null, so we have to manually clean up
        // the list post-removal instead
        function onObjectRemovedPost(object, index) {
            root.cleanupPlayers();
        }

        function onObjectInsertedPost(object, index) {
            root.touchPlayer(object);
        }
    }

    Instantiator {
        model: Mpris.players

        delegate: Connections {
            required property var modelData
            readonly property MprisPlayer player: modelData

            target: player

            function onPlaybackStateChanged() {
                if (player.playbackState === MprisPlaybackState.Playing) {
                    root.touchPlayer(player);
                }
            }
        }
    }
}
