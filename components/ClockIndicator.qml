import QtQuick
import "../utils"

Indicator {
    id: root

    horizontalPadding: 12

    Text {
        horizontalAlignment: Text.AlignHCenter
        text: Time.time
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        font.weight: Font.Bold
        color: Theme.text
    }
}
