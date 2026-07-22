pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import "../utils"
import "../bar" as Bar
import "." as Lock

Item {
    id: root

    required property var context
    required property var screen

    readonly property string mainMonitor: Quickshell.env("MAIN_MONITOR")

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
        target: screencopy
        property: "opacity"
        from: 1
        to: 0
        duration: root.context.animate ? Theme.animDurationLong : 0
        easing.type: Theme.animEasing
        running: true
        onFinished: root.context.animate = true
    }

    NumberAnimation {
        id: exitAnimation
        target: screencopy
        property: "opacity"
        from: 0
        to: 1
        duration: Theme.animDurationLong
        easing.type: Theme.animEasing
        onFinished: Lock.Controller.unlock()
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
                source: Colors.wallpaper
                fillMode: Image.PreserveAspectCrop
            }

            MultiEffect {
                anchors.fill: parent
                source: wallpaper

                blurEnabled: true
                blur: 1.0
                blurMax: 64
                blurMultiplier: 1.5
                autoPaddingEnabled: false
            }

            Rectangle {
                anchors.fill: parent
                color: Qt.alpha(Theme.base, 0.15)
            }
        }

        Loader {
            anchors.fill: parent
            active: !root.mainMonitor || root.screen?.name === root.mainMonitor

            sourceComponent: Item {
                anchors.fill: parent

                Item {
                    id: fakeBar

                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.left: parent.left

                    implicitHeight: 40

                    WrapperItem {
                        anchors.fill: parent
                        margin: Theme.spacingTiny

                        Item {
                            RowLayout {
                                anchors.right: parent.right
                                spacing: Theme.spacingTiny

                                Loader {
                                    active: Players.hasActivePlayer
                                    sourceComponent: Bar.MediaIndicator {
                                        clickable: false
                                        backgroundColor: Theme.text
                                        backgroundOpacity: 0.15
                                        showBackgroundImage: false
                                    }
                                }

                                Bar.StatusIndicator {
                                    Layout.preferredWidth: implicitWidth + 8
                                    clickable: false
                                    backgroundColor: Theme.text
                                    backgroundOpacity: 0.15
                                }
                            }
                        }
                    }
                }

                ColumnLayout {
                    y: 128
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 0

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Qt.formatDateTime(Time.date, "dddd, MMMM d")
                        font.family: Theme.fontFamily
                        font.pixelSize: 36
                        font.weight: Font.DemiBold
                        color: Theme.text
                        renderTypeQuality: Text.HighRenderTypeQuality
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Qt.formatDateTime(Time.date, "hh:mm")
                        font.family: Theme.fontFamily
                        font.pixelSize: 144
                        font.weight: Font.Bold
                        color: Theme.text
                        renderTypeQuality: Text.VeryHighRenderTypeQuality
                    }
                }

                ColumnLayout {
                    y: parent.height - height - 80
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 24

                    ClippingRectangle {
                        Layout.alignment: Qt.AlignHCenter
                        implicitHeight: 96
                        implicitWidth: 96
                        radius: height / 2

                        Image {
                            anchors.fill: parent
                            source: Quickshell.env("HOME") + "/.dotfiles/assets/avatar.png"
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Formatters.capitalize(Quickshell.env("USER"))
                        font.family: Theme.fontFamily
                        font.pixelSize: 20
                        font.weight: Font.DemiBold
                        color: Theme.text
                    }

                    TextField {
                        id: passwordBox
                        Layout.alignment: Qt.AlignHCenter

                        implicitWidth: 240
                        implicitHeight: 40
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.text
                        padding: Theme.spacingMedium

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        background: Rectangle {
                            color: Qt.alpha(Theme.text, 0.15)
                            radius: height / 2
                        }

                        Text {
                            anchors.fill: parent
                            anchors.margins: passwordBox.padding

                            text: passwordBox.text.length === 0 ? "Enter password" : ""
                            color: Theme.text
                            font: passwordBox.font

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        enabled: !root.context.unlockInProgress

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

                            function onPamFailure() {
                                passwordBox.text = "";
                            }
                        }
                    }

                    Text {
                        opacity: root.showStatusMessage ? 1 : 0
                        Layout.alignment: Qt.AlignHCenter
                        text: root.statusMessage
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.text
                    }
                }
            }
        }
    }

    Item {
        id: screencopy
        anchors.fill: parent

        Image {
            source: "/tmp/lock_screencopy.jpg"

            x: -root.screen?.x ?? 0
            y: -root.screen?.y ?? 0

            width: sourceSize.width
            height: sourceSize.height
        }
    }

    Connections {
        target: root.context

        function onPamSuccess() {
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
