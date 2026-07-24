import QtQuick
import "../utils"

Indicator {
    id: root

    horizontalPadding: 12

    Text {
        horizontalAlignment: Text.AlignHCenter
        text: Qt.formatDateTime(Time.date, "MMM d hh:mm")
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        font.weight: Font.Bold
        color: root.textColor
    }
}
