import QtQuick
import "../utils"

Widget {
    horizontalPadding: 12

    Text {
        horizontalAlignment: Text.AlignHCenter
        text: Time.time
        font.family: "NotoSans Nerd Font Propo"
        font.bold: true
        font.pixelSize: 16
        color: Colors.md3.on_background
    }
}
