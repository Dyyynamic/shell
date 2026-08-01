import Quickshell.Widgets
import QtQuick
import "../utils"

Item {
    id: root

    default property alias contentData: content.data

    property alias contentMargin: content.margin
    property alias contentBottomMargin: content.bottomMargin
    property alias backgroundColor: background.color

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    Rectangle {
        id: background
        anchors.fill: parent
        color: Colors.md3.surface_container_low
        radius: Theme.radiusMedium
    }

    WrapperItem {
        id: content
        anchors.fill: parent
        margin: Theme.spacingSmall
        bottomMargin: Theme.spacingSmall
    }
}
