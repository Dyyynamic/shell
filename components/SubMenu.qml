import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "../utils"

Item {
    id: root

    property alias title: titleText.text
    property alias placeholder: placeholderText.text
    property alias footerText: footerButton.text
    property alias model: listView.model
    property alias delegate: listView.delegate

    readonly property bool hasItems: listView.model && listView.count > 0

    implicitHeight: content.implicitHeight

    signal backRequested
    signal closeRequested
    signal settingsRequested

    ColumnLayout {
        id: content

        width: parent.width
        spacing: Theme.spacingMedium

        WrapperItem {
            margin: Theme.spacingTiny

            RowLayout {
                spacing: Theme.spacingSmall

                IconButton {
                    iconText: ""
                    onClicked: root.backRequested()
                    size: 32
                    iconSize: 20
                }

                Text {
                    id: titleText
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    font.weight: Font.Bold
                    color: Theme.text
                }
            }
        }

        Item {
            visible: !root.hasItems

            Layout.fillWidth: true
            Layout.preferredHeight: 50

            Text {
                id: placeholderText

                anchors.centerIn: parent

                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeTiny
                color: Theme.textSecondary
            }
        }

        ListView {
            id: listView

            visible: root.hasItems

            Layout.fillWidth: true
            Layout.leftMargin: Theme.spacingSmall
            Layout.rightMargin: Theme.spacingSmall

            implicitHeight: Math.min(contentHeight, 200)
            interactive: contentHeight > height

            spacing: Theme.spacingMedium
            clip: true
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 1
            color: Theme.overlay

            Layout.leftMargin: Theme.spacingSmall
            Layout.rightMargin: Theme.spacingSmall
        }

        RegularButton {
            id: footerButton
            text: "Settings"
            color: Theme.surface
            onClicked: {
                root.closeRequested();
                root.settingsRequested();
            }
        }
    }
}
