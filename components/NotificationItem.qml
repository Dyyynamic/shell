import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../utils"

Item {
    id: root

    required property Notification notification

    readonly property int radius: 12
    readonly property var defaultAction: {
        return root.notification.actions.find(action => {
            return action.identifier === "default";
        });
    }
    readonly property var actions: {
        return root.notification.actions.filter(action => {
            return action.identifier !== "default";
        });
    }

    signal activated

    width: parent.width
    implicitHeight: content.implicitHeight

    Rectangle {
        id: content
        width: parent.width
        implicitHeight: wrapper.implicitHeight
        radius: root.radius

        color: {
            if (mouseArea.pressed)
                return Qt.lighter(Theme.overlay, Theme.pressedMultiplier);
            if (mouseArea.containsMouse)
                return Qt.lighter(Theme.overlay, Theme.hoverMultiplier);
            return Theme.overlay;
        }

        Behavior on color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        property bool hovered: false
        property bool pressed: false

        MouseArea {
            id: mouseArea

            anchors.fill: parent
            enabled: !!root.defaultAction
            hoverEnabled: true

            onClicked: {
                root.defaultAction.invoke();
                root.activated();
            }
        }

        WrapperItem {
            id: wrapper
            margin: 12
            width: parent.width

            RowLayout {
                spacing: 12

                ClippingRectangle {
                    Layout.alignment: Qt.AlignTop
                    implicitWidth: 64
                    implicitHeight: 64
                    radius: width / 2

                    visible: !!root.notification.image

                    Image {
                        anchors.fill: parent
                        source: root.notification.image
                        fillMode: Image.PreserveAspectCrop
                    }
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignTop

                    RowLayout {
                        Text {
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                            text: {
                                if (root.notification.appName) {
                                    root.notification.appName;
                                } else {
                                    "Notification";
                                }
                            }
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeTiny
                            color: Theme.text
                        }

                        Text {
                            text: Qt.formatTime(new Date(root.notification.time), "hh:mm")
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeTiny
                            color: Theme.text
                        }

                        IconButton {
                            id: dismissButton

                            iconText: ""
                            size: 20

                            onClicked: root.notification.dismiss()
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        text: root.notification.summary
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        font.bold: true
                    }

                    Text {
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                        text: root.notification.body
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 5

                        visible: root.actions.length > 0

                        Repeater {
                            model: root.actions

                            Button {
                                id: defaultActionButton

                                required property var modelData

                                Layout.fillWidth: true
                                Layout.preferredWidth: parent.width / root.actions.length

                                icon.name: root.notification.hasActionIcons ? modelData.identifier : ""
                                text: root.notification.hasActionIcons ? "" : modelData.text
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeTiny
                                implicitHeight: 30
                                padding: 8

                                background: Rectangle {
                                    color: {
                                        if (defaultActionButton.pressed)
                                            return Qt.lighter(Theme.overlayHigh, Theme.pressedMultiplier);
                                        if (defaultActionButton.hovered)
                                            return Qt.lighter(Theme.overlayHigh, Theme.hoverMultiplier);
                                        return Theme.overlayHigh;
                                    }
                                    radius: 10

                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 200
                                            easing.type: Easing.OutCubic
                                        }
                                    }
                                }

                                onClicked: {
                                    modelData.invoke();
                                    root.activated();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
