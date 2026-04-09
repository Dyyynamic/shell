import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../utils"

Flickable {
    id: swipe

    required property var notification

    width: parent.width
    implicitHeight: content.implicitHeight

    flickableDirection: Flickable.HorizontalFlick

    onDragEnded: {
        if (Math.abs(contentX) > 30) {
            swipe.notification.dismiss();
        }
    }

    Rectangle {
        id: content
        width: parent.width
        implicitHeight: wrapper.implicitHeight
        color: Qt.lighter(Colors.md3.background, 2)
        radius: 12

        WrapperItem {
            id: wrapper
            margin: 14

            ColumnLayout {
                RowLayout {
                    Text {
                        text: swipe.notification.summary
                        color: Colors.md3.on_background
                        font.pixelSize: 14
                        font.bold: true
                    }
                    Text {
                        text: Qt.formatTime(new Date(swipe.notification.time), "hh:mm")
                        color: Colors.md3.on_background
                        font.pixelSize: 12
                    }
                }
                Text {
                    text: swipe.notification.body
                    color: Colors.md3.on_background
                    font.pixelSize: 14
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
