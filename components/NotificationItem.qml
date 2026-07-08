import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import "../utils"

Item {
    id: item

    required property Notification notification

    signal exitFinished
    signal activated
    signal aboutToDestroy

    width: parent.width
    implicitHeight: content.implicitHeight

    function exit() {
        exitAnimation.start();
    }

    Rectangle {
        id: content
        width: parent.width
        implicitHeight: wrapper.implicitHeight
        color: {
            if (item.notification.actions.length == 0)
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

                    // If resident is false, the notification will be dismissed
                    if (!item.notification.resident) {
                        item.exit();
                    }

                    item.notification.actions[0].invoke();
                    item.activated();
                }
            }
        }

        WrapperItem {
            id: wrapper
            margin: 14
            width: parent.width

            RowLayout {
                spacing: 14

                ClippingRectangle {
                    implicitWidth: 56
                    implicitHeight: 56
                    radius: width / 2

                    visible: !!item.notification.image

                    Image {
                        source: item.notification.image
                        anchors.fill: parent
                    }
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignTop

                    RowLayout {
                        Text {
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                            text: item.notification.summary
                            color: Colors.md3.on_background
                            font.pixelSize: 14
                            font.bold: true
                        }

                        Text {
                            text: Qt.formatTime(new Date(item.notification.time), "hh:mm")
                            color: Colors.md3.on_background
                            font.pixelSize: 12
                        }

                        IconButton {
                            id: dismissButton

                            iconText: ""
                            size: 22

                            onClicked: item.notification.dismiss()
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                        text: item.notification.body
                        color: Colors.md3.on_background
                        font.pixelSize: 14
                    }
                }
            }
        }
    }

    NumberAnimation {
        id: exitAnimation
        target: item
        property: "opacity"
        to: 0
        duration: 200
        easing.type: Easing.OutCubic
        onFinished: {
            lock.locked = false;
            item.exitFinished();
        }
    }

    RetainableLock {
        id: lock
        object: item.notification
        locked: true

        onDropped: item.exit()
        onAboutToDestroy: item.aboutToDestroy()
    }
}
