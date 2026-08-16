import QtQuick
import "../utils"

Item {
    id: root

    default property alias contentData: content.data

    property alias margins: content.anchors.margins
    property alias leftMargin: content.anchors.leftMargin
    property alias rightMargin: content.anchors.rightMargin
    property alias topMargin: content.anchors.topMargin
    property alias bottomMargin: content.anchors.bottomMargin

    property alias backgroundColor: background.color

    implicitWidth: content.implicitWidth + leftMargin + rightMargin
    implicitHeight: content.implicitHeight + topMargin + bottomMargin

    Rectangle {
        id: background
        anchors.fill: parent
        color: Colors.md3.surface_container_low
        radius: Theme.radiusMedium
    }

    Item {
        id: content
        anchors.fill: parent
        anchors.margins: Theme.spacingSmall

        implicitHeight: childrenRect.height
        implicitWidth: childrenRect.width
    }
}
