import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../utils"

Flickable {
    id: item

    required property var notification

    property bool showExpandButton: false
    property bool expanded: false
    property string expandLabel: ""

    property alias radius: content.radius
    property alias topLeftRadius: content.topLeftRadius
    property alias topRightRadius: content.topRightRadius
    property alias bottomLeftRadius: content.bottomLeftRadius
    property alias bottomRightRadius: content.bottomRightRadius

    signal expandClicked()
    signal dismissed()

    width: parent.width
    implicitHeight: content.implicitHeight

    flickableDirection: Flickable.HorizontalFlick

    onDragEnded: {
        if (Math.abs(contentX) > 30) {
            dismissed()
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

                        NotifExpandButton {
                            visible: item.showExpandButton
                            icon: item.expanded ? "" : ""
                            label: item.expandLabel
                            onClicked: item.expandClicked()
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
}
