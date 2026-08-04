pragma ComponentBehavior: Bound

import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import "../components" as Components
import "../utils"

Item {
    id: root

    required property var controller
    required property var context
    required property var screen

    property bool capsLock: false

    property string statusMessage: {
        if (context.showFailure)
            return "Authentication failed";
        if (capsLock)
            return "Caps lock on";
        return "";
    }
    property bool showStatusMessage: context.showFailure || capsLock

    NumberAnimation {
        id: enterAnimation
        target: blackScreen
        property: "opacity"
        from: 1
        to: 0
        duration: Theme.durationAtmospheric
        easing.type: Theme.easingStandard
        running: true
    }

    NumberAnimation {
        id: exitAnimation
        target: blackScreen
        property: "opacity"
        from: 0
        to: 1
        duration: Theme.durationAtmospheric
        easing.type: Theme.easingStandard
        onFinished: root.controller.unlock()
    }

    Item {
        id: surface
        anchors.fill: parent

        Item {
            id: background
            anchors.fill: parent

            Image {
                id: wallpaper
                anchors.fill: parent
                source: "/var/lib/greetd/wallpaper.png"
                fillMode: Image.PreserveAspectCrop
            }

            MultiEffect {
                anchors.fill: parent
                source: wallpaper

                blurEnabled: true
                blur: 1
                blurMax: 64
                blurMultiplier: 1.5
                autoPaddingEnabled: false
            }

            Rectangle {
                anchors.fill: parent
                color: Qt.alpha("black", 0.15)
            }
        }

        Loader {
            anchors.fill: parent
            active: root.screen?.name === Screens.main.name

            sourceComponent: Item {
                anchors.fill: parent

                ColumnLayout {
                    y: 64
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 0

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Qt.formatDateTime(Time.date, "dddd, MMMM d")
                        font.family: Theme.fontFamily
                        font.pixelSize: 18
                        font.weight: Font.DemiBold
                        color: "#e3e3e3"
                        renderTypeQuality: Text.HighRenderTypeQuality
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Qt.formatDateTime(Time.date, "hh:mm")
                        font.family: Theme.fontFamily
                        font.pixelSize: 72
                        font.weight: Font.Bold
                        color: "#e3e3e3"
                        renderTypeQuality: Text.VeryHighRenderTypeQuality
                    }
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 24

                    ClippingRectangle {
                        Layout.alignment: Qt.AlignHCenter
                        implicitHeight: 144
                        implicitWidth: 144
                        radius: height / 2

                        Image {
                            anchors.fill: parent
                            source: "/var/lib/greetd/avatar.png"
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Dynamic"
                        font.family: Theme.fontFamily
                        font.pixelSize: 20
                        font.weight: Font.DemiBold
                        color: "#e3e3e3"
                    }

                    TextField {
                        id: passwordBox
                        Layout.alignment: Qt.AlignHCenter

                        implicitWidth: 240
                        implicitHeight: 40
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeMedium
                        color: "#e3e3e3"
                        padding: Theme.spacingMedium

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        background: Rectangle {
                            color: Qt.alpha("#e3e3e3", 0.15)
                            radius: height / 2
                        }

                        Text {
                            anchors.fill: parent
                            anchors.margins: passwordBox.padding

                            text: passwordBox.text.length === 0 ? "Enter password" : ""
                            color: "#e3e3e3"
                            font: passwordBox.font

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        enabled: !root.context.isUnlocking

                        echoMode: TextInput.Password
                        inputMethodHints: Qt.ImhHiddenText

                        Component.onCompleted: passwordBox.forceActiveFocus()

                        onTextChanged: () => {
                            if (text != "") {
                                root.context.showFailure = false;
                            }
                        }

                        onAccepted: () => {
                            root.context.tryUnlock(text);
                        }

                        Connections {
                            target: root.context

                            function onGreetdFailure() {
                                passwordBox.text = "";
                            }
                        }
                    }

                    Text {
                        opacity: root.showStatusMessage ? 1 : 0
                        Layout.alignment: Qt.AlignHCenter
                        text: root.statusMessage
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeMedium
                        color: "#e3e3e3"
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: systemMenu.show = false
                    enabled: systemMenu.show
                    visible: systemMenu.show
                }

                Components.IconButton {
                    id: powerButton

                    anchors {
                        right: parent.right
                        bottom: parent.bottom
                        rightMargin: 32
                        bottomMargin: 32
                    }

                    iconGlyph: ""
                    iconColor: "#e3e3e3"
                    backgroundColor: "#e3e3e3"
                    backgroundOpacity: {
                        if (pressed)
                            return 0.35;
                        if (hovered)
                            return 0.25;
                        return 0.15;
                    }

                    onClicked: systemMenu.show = !systemMenu.show
                }

                SystemMenu {
                    id: systemMenu
                    powerButton: powerButton
                }
            }
        }
    }

    Rectangle {
        id: blackScreen

        anchors.fill: parent
        color: "black"
    }

    Connections {
        target: root.context

        function onGreetdSuccess() {
            exitAnimation.start();
        }
    }

    // Too Expensive!
    Process {
        running: true
        onRunningChanged: if (!running)
            running = true

        command: ["hyprctl", "-j", "devices"]

        stdout: StdioCollector {
            onStreamFinished: {
                const devices = JSON.parse(this.text);
                const mainKeyboard = devices.keyboards.find(kb => {
                    return kb.main == true;
                });
                root.capsLock = mainKeyboard?.capsLock;
            }
        }
    }
}
