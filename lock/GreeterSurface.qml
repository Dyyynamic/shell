pragma ComponentBehavior: Bound

import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../components" as Components
import "../utils"
import "." as Lock

Item {
    id: root

    required property var controller
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

        Lock.Background {
            wallpaper: "/var/lib/greetd/wallpaper.png"
        }

        Loader {
            anchors.fill: parent
            active: root.screen?.name === Screens.main.name

            sourceComponent: Item {
                anchors.fill: parent

                ColumnLayout {
                    anchors {
                        top: parent.top
                        topMargin: 64
                        horizontalCenter: parent.horizontalCenter
                    }

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
                    id: login

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

        function onSuccess() {
            exitAnimation.start();
        }
    }

    CapsLockMonitor {
        id: capsLockMonitor
    }
}
