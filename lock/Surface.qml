pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../utils"
import "../bar" as Bar
import "../capture" as Capture
import "." as Lock

Item {
    id: root

    required property var context
    required property var screen

    property string statusMessage: {
        if (context.showFailure)
            return "Authentication failed";
        if (capsLockMonitor.capsLock)
            return "Caps lock on";
        return "";
    }
    property bool showStatusMessage: context.showFailure || capsLockMonitor.capsLock

    NumberAnimation {
        id: enterAnimation
        target: screencopy
        property: "opacity"
        from: 1
        to: 0
        duration: root.context.animate ? Theme.durationAtmospheric : 0
        easing.type: Theme.easingStandard
        running: true
        onFinished: root.context.animate = true
    }

    NumberAnimation {
        id: exitAnimation
        target: screencopy
        property: "opacity"
        from: 0
        to: 1
        duration: Theme.durationAtmospheric
        easing.type: Theme.easingStandard
        onFinished: Lock.Controller.unlock()
    }

    Item {
        id: surface
        anchors.fill: parent

        Lock.Background {
            wallpaper: Theme.wallpaper
        }

        Loader {
            anchors.fill: parent
            active: root.screen?.name === Screens.main.name

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
                                    visible: Capture.Controller.isRecording
                                    active: Capture.Controller.isRecording
                                    sourceComponent: Bar.RecordingIndicator {
                                        clickable: false
                                        backgroundColor: "#e3e3e3"
                                        backgroundOpacity: 0.15
                                        textColor: "#e3e3e3"
                                        showBackgroundImage: false
                                    }
                                }

                                Loader {
                                    visible: Players.players.length > 0
                                    active: Players.players.length > 0
                                    sourceComponent: Bar.MediaIndicator {
                                        clickable: false
                                        backgroundColor: "#e3e3e3"
                                        backgroundOpacity: 0.15
                                        textColor: "#e3e3e3"
                                        showBackgroundImage: false
                                    }
                                }

                                Bar.StatusIndicator {
                                    Layout.preferredWidth: implicitWidth + 8
                                    clickable: false
                                    backgroundColor: "#e3e3e3"
                                    backgroundOpacity: 0.15
                                    textColor: "#e3e3e3"
                                }
                            }
                        }
                    }
                }

                ColumnLayout {
                    anchors {
                        top: parent.top
                        topMargin: 128
                        horizontalCenter: parent.horizontalCenter
                    }

                    spacing: 0

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Qt.formatDateTime(Time.date, "dddd, MMMM d")
                        font.family: Theme.fontFamily
                        font.pixelSize: 36
                        font.weight: Font.DemiBold
                        color: "#e3e3e3"
                        renderTypeQuality: Text.HighRenderTypeQuality
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Qt.formatDateTime(Time.date, "hh:mm")
                        font.family: Theme.fontFamily
                        font.pixelSize: 144
                        font.weight: Font.Bold
                        color: "#e3e3e3"
                        renderTypeQuality: Text.VeryHighRenderTypeQuality
                    }
                }

                ColumnLayout {
                    id: login

                    anchors {
                        bottom: parent.bottom
                        bottomMargin: 128
                        horizontalCenter: parent.horizontalCenter
                    }

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
                        color: "#e3e3e3"
                    }

                    Lock.PasswordBox {
                        context: root.context
                    }
                }

                Text {
                    anchors {
                        top: login.bottom
                        topMargin: 24
                        horizontalCenter: parent.horizontalCenter
                    }

                    opacity: root.showStatusMessage ? 1 : 0
                    Layout.alignment: Qt.AlignHCenter
                    text: root.statusMessage
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeMedium
                    color: "#e3e3e3"
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

        function onSuccess() {
            exitAnimation.start();
        }
    }

    CapsLockMonitor {
        id: capsLockMonitor
    }
}
