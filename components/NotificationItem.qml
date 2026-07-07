import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../utils"

Item {
    id: item

    required property var notification
    property bool closing: false

    signal dismissed
    signal closed

    opacity: closing ? 0 : 1
    width: parent.width
    implicitHeight: content.implicitHeight

    Rectangle {
        id: content
        width: parent.width
        implicitHeight: wrapper.implicitHeight
        color: Qt.lighter(Colors.md3.background, 2)
        radius: 12

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

                        Button {
                            id: dismissButton

                            text: ""
                            flat: true
                            implicitWidth: 22
                            implicitHeight: 22

                            onClicked: {
                                item.closing = true;
                                item.notification.dismiss()
                                item.dismissed()
                            }

                            background: Rectangle {
                                anchors.fill: parent
                                radius: 16
                                color: {
                                    if (dismissButton.pressed) {
                                        Qt.lighter(Colors.md3.background, 3);
                                    } else {
                                        if (dismissButton.hovered) {
                                            Qt.lighter(Colors.md3.background, 2.5);
                                        } else {
                                            Qt.lighter(Colors.md3.background, 2);
                                        }
                                    }
                                }
                            }
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

    Behavior on opacity {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
            onRunningChanged: {
                if (!running) {
                    // Release lock after animation is finished
                    lock.locked = false
                    item.closed()
                }
            }
        }
    }

    RetainableLock {
        id: lock
        object: item.notification
        locked: true
    }
}
