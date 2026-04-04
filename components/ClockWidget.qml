import QtQuick
import Quickshell.Io

Widget {
    onClicked: () => swaync.startDetached()

    Text {
        width: implicitWidth + 8
        horizontalAlignment: Text.AlignHCenter
        text: Time.time
        font.family: "NotoSans Nerd Font Propo"
        font.bold: true
        font.pixelSize: 16
        color: palette.windowText
    }

    Process {
        id: swaync
        command: ["swaync-client", "-t", "-sw"]
    }
}
