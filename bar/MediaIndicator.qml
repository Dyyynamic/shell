import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../utils"
import "../components" as Components

Indicator {
    id: root

    rightMargin: Theme.spacingMedium

    clickable: Players.players[0].canRaise
    onClicked: Players.players[0].raise()

    backgroundOpacity: !!Players.players[0].trackArtUrl ? 0.75 : 1

    backgroundData: [
        Image {
            id: trackArtBackground
            anchors.fill: parent
            source: Players.players[0].trackArtUrl
            fillMode: Image.PreserveAspectCrop
            visible: !!Players.players[0].trackArtUrl
        },
        MultiEffect {
            anchors.fill: parent
            source: trackArtBackground

            blurEnabled: true
            blur: 1
            blurMax: 32
            autoPaddingEnabled: false
        }
    ]

    RowLayout {
        Components.Icon {
            icon: ""
            color: root.textColor
        }

        Text {
            horizontalAlignment: Text.AlignHCenter
            text: Players.players[0].trackTitle
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeLarge
            font.weight: Font.Bold
            color: root.textColor
            elide: Text.ElideRight
            Layout.maximumWidth: 200
        }
    }
}
