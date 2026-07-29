import Quickshell
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

    readonly property alias pressed: mouseArea.pressed
    readonly property alias hovered: mouseArea.containsMouse

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

    // Needed for popup shadow
    readonly property alias radius: background.radius

    width: parent.width
    height: content.implicitHeight

    Rectangle {
        id: background
        anchors.fill: parent
        radius: Theme.radiusSmall

        color: {
            if (root.defaultAction && root.pressed)
                return Theme.colorMix(Theme.overlay, Theme.text, Theme.pressIntensity);
            if (root.defaultAction && root.hovered)
                return Theme.colorMix(Theme.overlay, Theme.text, Theme.hoverIntensity);
            return Theme.overlay;
        }

        Behavior on color {
            ColorAnimation {
                duration: Theme.durationFast
                easing.type: Theme.easingStandard
            }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            if (!root.defaultAction)
                return;

            root.defaultAction.invoke();
            ControlCenter.Controller.close();
        }
    }

    WrapperItem {
        id: content

        width: parent.width
        margin: Theme.spacingMedium

        ColumnLayout {
            spacing: 8

            RowLayout {
                spacing: Theme.spacingTiny

                Text {
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    text: {
                        if (root.notification.appName)
                            return root.notification.appName;
                        return "Notification";
                    }
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeTiny
                    font.weight: Font.Medium
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
                    backgroundOpacity: hovered ? 1 : 0;

                    onClicked: root.notification.dismiss()
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingMedium

                ClippingRectangle {
                    Layout.alignment: Qt.AlignTop
                    implicitWidth: 64
                    implicitHeight: 64

                    radius: Theme.radiusTiny
                    color: "transparent"

                    visible: !!root.notification.image

                    Image {
                        anchors.fill: parent
                        source: root.notification.image
                        fillMode: Image.PreserveAspectCrop
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingTiny

                    // Force layout to calculate height instead of using Text's
                    // single-line implicitWidth
                    // Otherwise, popup notifications can overlap
                    Layout.preferredWidth: 0

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
                                            duration: Theme.durationFast
                                            easing.type: Theme.easingStandard
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

    RetainableLock {
        object: root.notification
        locked: true
    }
}
