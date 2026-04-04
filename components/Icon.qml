import QtQuick

Item {
    property alias icon: textItem.text

    width: 20
    height: 20

    Text {
        id: textItem
        anchors.centerIn: parent

        font.family: "NotoSans Nerd Font Propo"
        font.bold: true
        font.pixelSize: 16
        color: palette.windowText
    }
}
