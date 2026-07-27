import QtQuick
import QtQuick.Layouts
import "../utils"
import "../components" as Components

Indicator {
    id: root

    rightMargin: Theme.spacingMedium

    clickable: true

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter

        Components.Icon {
            icon: "󰻃"
            color: Theme.error
        }

        Text {
            horizontalAlignment: Text.AlignHCenter
            text: Formatters.formatTime(Recording.duration)
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            font.weight: Font.Bold
            color: root.textColor
        }
    }
}
