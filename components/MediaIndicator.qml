import QtQuick
import QtQuick.Layouts
import "../utils"

Indicator {
    id: root

    clickable: PlayerStore.lastPlayedPlayer.canRaise
    onClicked: PlayerStore.lastPlayedPlayer.raise()

    backgroundData: [
        Image {
            anchors.fill: parent
            source: PlayerStore.lastPlayedPlayer.trackArtUrl
            fillMode: Image.PreserveAspectCrop
            visible: !!PlayerStore.lastPlayedPlayer.trackArtUrl
        },
        Rectangle {
            anchors.fill: parent
            color: {
                if (root.pressed)
                    return Qt.lighter(Theme.overlay, Theme.pressedMultiplier);
                if (root.hovered)
                    return Qt.lighter(Theme.overlay, Theme.hoverMultiplier);
                return Theme.overlay;
            }
            opacity: !!PlayerStore.lastPlayedPlayer.trackArtUrl ? 0.75 : 1

            Behavior on color {
                ColorAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }
    ]

    RowLayout {
        Icon {
            icon: ""
        }

        Text {
            horizontalAlignment: Text.AlignHCenter
            text: PlayerStore.lastPlayedPlayer.trackTitle
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            font.bold: true
            color: Theme.text
            elide: Text.ElideRight
            Layout.maximumWidth: 200
        }
    }
}
