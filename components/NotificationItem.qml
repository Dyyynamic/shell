import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import "../utils"

Item {
    id: item

    required property Notification notification
    property alias radius: content.radius

    signal activated

    width: parent.width
    implicitHeight: content.implicitHeight

    Rectangle {
        id: content
        width: parent.width
        implicitHeight: wrapper.implicitHeight
        color: {
            if (item.notification.actions.length === 0)
                return Qt.lighter(Colors.md3.background, 2);
            if (pressed)
                return Qt.lighter(Colors.md3.background, 3);
            if (hovered)
                return Qt.lighter(Colors.md3.background, 2.5);
            else
                return Qt.lighter(Colors.md3.background, 2);
        }
        radius: 12

        property bool hovered: false
        property bool pressed: false

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: content.hovered = true
            onExited: content.hovered = false
            onPressed: content.pressed = true
            onReleased: content.pressed = false
            onClicked: {
                if (item.notification.actions.length > 0) {
                    const action = item.notification.actions[0];

                    action.invoke();
                    item.activated();
                }
            }
        }

        WrapperItem {
            id: wrapper
            margin: 12
            width: parent.width

            RowLayout {
                spacing: 12

                ClippingRectangle {
                    implicitWidth: 64
                    implicitHeight: 64
                    radius: width / 2

                    visible: !!item.notification.image

                    Image {
                        anchors.fill: parent
                        source: item.notification.image
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
                                if (item.notification.appName) {
                                    item.notification.appName;
                                } else {
                                    "Notification";
                                }
                            }
                            font.family: "NotoSans Nerd Font Propo"
                            color: Colors.md3.on_background
                            font.pixelSize: 12
                        }

                        Text {
                            text: Qt.formatTime(new Date(item.notification.time), "hh:mm")
                            font.family: "NotoSans Nerd Font Propo"
                            color: Colors.md3.on_background
                            font.pixelSize: 12
                        }

                        IconButton {
                            id: dismissButton

                            iconText: ""
                            size: 20

                            onClicked: item.notification.dismiss()
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        text: item.notification.summary
                        color: Colors.md3.on_background
                        font.family: "NotoSans Nerd Font Propo"
                        font.pixelSize: 14
                        font.bold: true
                    }

                    Text {
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                        text: item.notification.body
                        color: Colors.md3.on_background
                        font.family: "NotoSans Nerd Font Propo"
                        font.pixelSize: 14
                    }
                }
            }
        }
    }
}
