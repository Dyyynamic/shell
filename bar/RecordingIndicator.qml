import QtQuick
import QtQuick.Layouts
import "../utils"
import "../components" as Components
import "../capture" as Capture

Indicator {
    id: root

    rightMargin: Theme.spacingMedium

    clickable: true

    textColor: Colors.md3.on_error_container
    backgroundColor: Colors.md3.error_container
    hoverIntensity: Theme.hoverIntensity
    pressIntensity: Theme.pressIntensity

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter

        Components.Icon {
            icon: "󰻃"
            color: Colors.md3.on_error_container
        }

        Text {
            horizontalAlignment: Text.AlignHCenter
            text: Formatters.formatTime(Capture.Controller.recordingDuration)
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeLarge
            font.weight: Font.Bold
            color: Colors.md3.on_error_container
        }
    }
}
