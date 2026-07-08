import QtQuick.Layouts
import "../utils"

ColumnLayout {
    id: quickMenuSliders

    spacing: 10

    CustomSlider {
        icon: Volume.icon
        Layout.fillWidth: true

        from: 0
        to: 1
        value: Volume.value
        onMoved: Volume.setVolume(value)
    }

    CustomSlider {
        visible: Brightness.backlight
        icon: ""
        Layout.fillWidth: true
        value: Brightness.value

        onMoved: {
            Brightness.setBrightness(parseInt(value));
        }
    }
}
