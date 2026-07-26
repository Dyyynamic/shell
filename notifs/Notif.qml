import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../utils"
import "../components" as Components
import "../controlCenter" as ControlCenter

Item {
    id: root

    required property Notification notification

    readonly property int radius: Theme.radiusSmall
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

    width: parent.width
    implicitHeight: content.implicitHeight

    Rectangle {
        id: background
        anchors.fill: parent
        radius: root.radius

        color: {
            if (mouseArea.pressed)
                return Theme.colorMix(Theme.overlay, Theme.text, Theme.pressIntensity);
            if (mouseArea.containsMouse)
                return Theme.colorMix(Theme.overlay, Theme.text, Theme.hoverIntensity);
            return Theme.overlay;
        }

        Behavior on color {
            ColorAnimation {
                duration: Theme.animDurationShort
                easing.type: Theme.animEasing
            }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        enabled: !!root.defaultAction
        hoverEnabled: true

        onClicked: {
            root.defaultAction.invoke();
            ControlCenter.Controller.close();
        }
    }

    WrapperItem {
        id: content

        anchors.fill: parent
        margin: Theme.spacingMedium

        RowLayout {
            spacing: Theme.spacingMedium

            ClippingRectangle {
                Layout.alignment: Qt.AlignTop
                implicitWidth: 64
                implicitHeight: 64
                radius: height / 2

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
                        color: Theme.textVariant
                    }

                    Text {
                        text: Qt.formatTime(new Date(root.notification.time), "hh:mm")
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeTiny
                        color: Theme.textVariant
                    }

                    Components.IconButton {
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
                    font.weight: Font.DemiBold
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
                    spacing: Theme.spacingTiny

                    visible: root.actions.length > 0

                    Repeater {
                        model: root.actions

                        Button {
                            id: actionButton

                            required property var modelData

                            Layout.fillWidth: true
                            Layout.preferredWidth: parent.width / root.actions.length

                            icon.name: root.notification.hasActionIcons ? modelData.identifier : ""
                            text: root.notification.hasActionIcons ? "" : modelData.text
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeTiny
                            palette.buttonText: Theme.text
                            implicitHeight: 30
                            padding: 8

                            background: Rectangle {
                                color: {
                                    if (actionButton.pressed)
                                        return Theme.colorMix(Theme.overlayHigh, Theme.text, Theme.pressIntensity);
                                    if (actionButton.hovered)
                                        return Theme.colorMix(Theme.overlayHigh, Theme.text, Theme.hoverIntensity);
                                    return Theme.overlayHigh;
                                }
                                radius: Theme.radiusTiny

                                Behavior on color {
                                    ColorAnimation {
                                        duration: Theme.animDurationShort
                                        easing.type: Theme.animEasing
                                    }
                                }
                            }

                            onClicked: {
                                modelData.invoke();
                                ControlCenter.Controller.close();
                            }
                        }
                    }
                }
            }
        }
    }
}
