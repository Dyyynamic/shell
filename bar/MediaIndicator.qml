import QtQuick
import QtQuick.Layouts
import "../utils"
import "../components" as Components

Indicator {
    id: root

    clickable: Players.lastPlayedPlayer.canRaise
    onClicked: Players.lastPlayedPlayer.raise()

    backgroundOpacity: !!Players.lastPlayedPlayer.trackArtUrl ? 0.75 : 1

    backgroundData: [
        Image {
            anchors.fill: parent
            source: Players.lastPlayedPlayer.trackArtUrl
            fillMode: Image.PreserveAspectCrop
            visible: !!Players.lastPlayedPlayer.trackArtUrl
        }
    ]

    RowLayout {
        Components.Icon {
            icon: ""
            color: root.textColor
        }

        Text {
            horizontalAlignment: Text.AlignHCenter
            text: Players.lastPlayedPlayer.trackTitle
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            font.weight: Font.Bold
            color: root.textColor
            elide: Text.ElideRight
            Layout.maximumWidth: 200
        }
    }
}
