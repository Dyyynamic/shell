import Quickshell.Widgets
import QtQuick
import "../utils"

Item {
    id: root

    default property alias contentData: content.data

    property int contentMargin: Theme.spacingSmall
    property int contentBottomMargin: Theme.spacingSmall
    property color backgroundColor: Theme.surface

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    Rectangle {
        anchors.fill: parent
        color: root.backgroundColor
        radius: Theme.radiusMedium
    }

    WrapperItem {
        id: content
        anchors.fill: parent
        margin: root.contentMargin
        bottomMargin: root.contentBottomMargin
    }
}
