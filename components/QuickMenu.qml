import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import "../utils"

PanelWindow {
    id: menu

    required property var bar

    property bool open: false
    property var margin: 10

    property bool nightLightEnabled: false
    property bool darkModeEnabled: false

    property bool transitioning: false

    visible: open || transitioning

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    margins.top: bar.height
    exclusionMode: ExclusionMode.Ignore
    implicitWidth: screen.width
    color: "transparent"
    screen: bar.screen

    MouseArea {
        anchors.fill: parent

        onClicked: menu.open = false
    }

    Item {
        id: panelContainer

        width: 450
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }

        // Prevent clicks inside the panel from closing it
        MouseArea {
            anchors.fill: parent
        }

        WrapperItem {
            width: parent.width
            height: parent.height
            topMargin: menu.margin
            rightMargin: menu.margin
            bottomMargin: menu.margin

            Rectangle {
                id: background
                width: parent.width
                height: parent.height
                radius: 20
                color: Colors.md3.background
                border.color: Qt.lighter(Colors.md3.background, 1.5)

                opacity: menu.open ? 1 : 0
                x: menu.open ? 0 : width

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                        onRunningChanged: menu.transitioning = running
                    }
                }

                Behavior on x {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutQuad
                        onRunningChanged: menu.transitioning = running
                    }
                }

                WrapperItem {
                    id: wrapper
                    width: parent.width
                    height: parent.height
                    margin: 20

                    ColumnLayout {
                        spacing: 20
                        width: parent.width
                        height: parent.height

                        RowLayout {
                            spacing: 10

                            RowLayout {
                                spacing: 10

                                Icon {
                                    icon: "󰣇"
                                    size: 24
                                }
                                Text {
                                    id: uptimeText
                                    color: Colors.md3.on_background
                                    font.pixelSize: 14
                                }
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            RowLayout {
                                spacing: 10

                                IconButton {
                                    icon: ""
                                    onClicked: () => {
                                        menu.open = false;
                                        betterControl.startDetached();
                                    }
                                }
                                IconButton {
                                    icon: ""
                                    onClicked: () => {
                                        menu.open = false;
                                        powerMenu.running = true;
                                    }
                                }
                            }
                        }

                        ColumnLayout {
                            spacing: 10

                            CustomSlider {
                                icon: {
                                    if (!Pipewire.defaultAudioSink)
                                        return "";
                                    if (Pipewire.defaultAudioSink.audio.muted)
                                        return "";
                                    if (Pipewire.defaultAudioSink.audio.volume > 0.67)
                                        return "";
                                    if (Pipewire.defaultAudioSink.audio.volume > 0.33)
                                        return "";
                                    return "";
                                }
                                Layout.fillWidth: true

                                from: 0
                                to: 1
                                value: {
                                    if (Pipewire.defaultAudioSink)
                                        return Pipewire.defaultAudioSink.audio.volume;
                                    return 0;
                                }
                                onMoved: {
                                    if (Pipewire.defaultAudioSink)
                                        Pipewire.defaultAudioSink.audio.volume = value;
                                }

                                PwObjectTracker {
                                    objects: [Pipewire.defaultAudioSink]
                                }
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

                        ColumnLayout {
                            spacing: 10

                            RowLayout {
                                spacing: 10

                                ToggleButton {
                                    Layout.fillWidth: true
                                    icon: {
                                        if (!Network.enabled)
                                            return "󰤮";
                                        if (Network.signal > 80)
                                            return "󰤨";
                                        if (Network.signal > 60)
                                            return "󰤥";
                                        if (Network.signal > 40)
                                            return "󰤢";
                                        if (Network.signal > 20)
                                            return "󰤟";
                                        return "󰤯";
                                    }
                                    iconSize: 24
                                    text: "Network"
                                    subtext: Network.name ? Network.name : ""
                                    checked: Network.enabled
                                    onClicked: Network.toggle()
                                }
                                ToggleButton {
                                    Layout.fillWidth: true
                                    icon: "󰂯"
                                    iconSize: 24
                                    text: "Bluetooth"
                                    checked: Bluetooth.defaultAdapter.enabled
                                    onClicked: Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled
                                }
                            }

                            RowLayout {
                                spacing: 10

                                ToggleButton {
                                    Layout.fillWidth: true
                                    icon: ""
                                    iconSize: 24
                                    text: "Night Light"
                                    subtext: menu.nightLightEnabled ? "Active" : "Auto"
                                    checked: menu.nightLightEnabled
                                    onClicked: menu.nightLightEnabled = !menu.nightLightEnabled
                                }
                                ToggleButton {
                                    Layout.fillWidth: true
                                    icon: ""
                                    iconSize: 24
                                    text: "Dark Mode"
                                    subtext: menu.darkModeEnabled ? "Dark" : "Light"
                                    checked: menu.darkModeEnabled
                                    onClicked: menu.darkModeEnabled = !menu.darkModeEnabled
                                }
                            }
                        }

                        NotificationList {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            onNotificationActivated: menu.open = false
                        }

                        CustomCalendar {}
                    }
                }
            }
        }
    }

    Process {
        id: powerMenu
        command: ["walker", "--provider", "menus:system"]
    }

    Process {
        id: betterControl
        command: ["better-control"]
    }

    Process {
        id: uptime
        command: ["cat", "/proc/uptime"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let [uptime, idle] = text.split(" ");

                let hours = Math.floor(uptime / 3600);
                let minutes = Math.floor((uptime % 3600) / 60);
                uptimeText.text = `Up ${hours}h, ${minutes}m`;
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            uptime.running = true;
        }
    }
}
