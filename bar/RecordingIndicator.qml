import QtQuick
import QtQuick.Layouts
import "../utils"
import "../components" as Components
import "../capture" as Capture

Indicator {
    id: root

    rightMargin: Theme.spacingMedium

    clickable: true

    textColor: Theme.textError
    backgroundColor: Theme.error
    hoverIntensity: Theme.errorHoverIntensity
    pressIntensity: Theme.errorPressIntensity

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter

        Components.Icon {
            icon: "󰻃"
            color: root.textColor
        }

        Text {
            horizontalAlignment: Text.AlignHCenter
            text: Formatters.formatTime(Capture.Controller.recordingDuration)
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            font.weight: Font.Bold
            color: root.textColor
        }
    }
}
