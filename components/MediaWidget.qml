import QtQuick
import QtQuick.Layouts
import "../utils"

Widget {
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
                    return Qt.lighter(Colors.md3.background, 3.5)
                if (root.hovered)
                    return Qt.lighter(Colors.md3.background, 2.75)
                return Qt.lighter(Colors.md3.background, 2)
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
            font.family: "NotoSans Nerd Font Propo"
            font.bold: true
            font.pixelSize: 16
            color: Colors.md3.on_background
            elide: Text.ElideRight
            Layout.maximumWidth: 200
        }
    }
}
