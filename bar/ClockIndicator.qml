import QtQuick
import "../utils"

Indicator {
    id: root

    margin: 12

    Text {
        horizontalAlignment: Text.AlignHCenter
        text: Qt.formatDateTime(Time.date, "MMM d hh:mm")
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: root.textColor
    }
}
