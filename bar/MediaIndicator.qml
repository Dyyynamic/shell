import QtQuick
import QtQuick.Layouts
import "../utils"
import "../components" as Components

Indicator {
    id: root

    clickable: Players.lastPlayedPlayer.canRaise
    onClicked: Players.lastPlayedPlayer.raise()

    backgroundData: [
        Image {
            anchors.fill: parent
            source: Players.lastPlayedPlayer.trackArtUrl
            fillMode: Image.PreserveAspectCrop
            visible: !!Players.lastPlayedPlayer.trackArtUrl
        },
        Rectangle {
            anchors.fill: parent
            color: {
                if (root.pressed)
                    return Qt.lighter(Theme.overlay, Theme.pressMultiplier);
                if (root.hovered)
                    return Qt.lighter(Theme.overlay, Theme.hoverMultiplier);
                return Theme.overlay;
            }
            opacity: !!Players.lastPlayedPlayer.trackArtUrl ? 0.75 : 1

            Behavior on color {
                ColorAnimation {
                    duration: Theme.animationDuration
                    easing.type: Theme.animationEasing
                }
            }
        }
    ]

    RowLayout {
        Components.Icon {
            icon: ""
        }

        Text {
            horizontalAlignment: Text.AlignHCenter
            text: Players.lastPlayedPlayer.trackTitle
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            font.weight: Font.Bold
            color: Theme.text
            elide: Text.ElideRight
            Layout.maximumWidth: 200
        }
    }
}
