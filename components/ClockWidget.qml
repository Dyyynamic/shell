import QtQuick
import Quickshell.Io
import "../utils"

Widget {
    Text {
        width: contentWidth + 8
        horizontalAlignment: Text.AlignHCenter
        text: Time.time
        font.family: "NotoSans Nerd Font Propo"
        font.bold: true
        font.pixelSize: 16
        color: Colors.md3.on_background
    }
}
