import QtQuick.Layouts
import "../utils"

ColumnLayout {
    id: quickMenuSliders

    spacing: 10

    CustomSlider {
        trackHeight: 30
        trackRadius: 8
        handleHeight: 38

        icon: Volume.icon
        Layout.fillWidth: true

        from: 0
        to: 1
        value: Volume.value
        onMoved: Volume.setVolume(value)
    }

    CustomSlider {
        trackHeight: 30
        trackRadius: 8
        handleHeight: 38

        visible: Brightness.backlight
        icon: ""
        Layout.fillWidth: true
        value: Brightness.value

        onMoved: {
            Brightness.setBrightness(parseInt(value));
        }
    }
}
