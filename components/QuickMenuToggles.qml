import QtQuick.Layouts
import "../utils"

ColumnLayout {
    id: quickMenuToggles

    // Temporary
    property bool nightLightEnabled: false
    property bool darkModeEnabled: false

    spacing: 10

    RowLayout {
        spacing: 10

        ToggleButton {
            Layout.fillWidth: true
            iconText: Network.icon
            iconSize: 24
            title: "Network"
            subtitle: Network.name
            checked: Network.enabled
            onClicked: Network.toggle()
        }
        ToggleButton {
            Layout.fillWidth: true
            iconText: "󰂯"
            iconSize: 24
            title: "Bluetooth"
            checked: Bluetooth.enabled
            onClicked: Bluetooth.toggle()
        }
    }

    RowLayout {
        spacing: 10

        ToggleButton {
            Layout.fillWidth: true
            iconText: ""
            iconSize: 24
            title: "Night Light"
            subtitle: quickMenuToggles.nightLightEnabled ? "Active" : "Auto"
            checked: quickMenuToggles.nightLightEnabled
            onClicked: quickMenuToggles.nightLightEnabled = !quickMenuToggles.nightLightEnabled
        }
        ToggleButton {
            Layout.fillWidth: true
            iconText: ""
            iconSize: 24
            title: "Dark Mode"
            subtitle: quickMenuToggles.darkModeEnabled ? "Dark" : "Light"
            checked: quickMenuToggles.darkModeEnabled
            onClicked: quickMenuToggles.darkModeEnabled = !quickMenuToggles.darkModeEnabled
        }
    }
}
