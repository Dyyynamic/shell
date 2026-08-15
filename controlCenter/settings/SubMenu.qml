import QtQuick
import QtQuick.Layouts
import "../../utils"
import "../../components" as Components
import ".." as ControlCenter

Item {
    id: root

    property alias title: titleText.text
    property alias placeholder: placeholderText.text
    property alias footerText: footerButton.text
    property alias model: listView.model
    property alias delegate: listView.delegate

    property int listMargin: Theme.spacingSmall
    property int listLeftMargin: listMargin
    property int listRightMargin: listMargin

    property bool hasSwitch: false
    property alias switchChecked: toggleSwitch.checked

    readonly property bool hasItems: listView.model && listView.count > 0

    implicitHeight: content.implicitHeight

    signal backRequested
    signal settingsRequested
    signal switchToggled

    ColumnLayout {
        id: content

        width: parent.width
        spacing: Theme.spacingMedium

        RowLayout {
            spacing: Theme.spacingSmall

            Components.IconButton {
                iconGlyph: ""
                onClicked: root.backRequested()
                size: 32
                iconSize: 20
            }

            Text {
                id: titleText
                Layout.fillWidth: true
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeLarge
                font.weight: Font.Bold
                color: Colors.md3.on_surface
            }

            Components.Switch {
                id: toggleSwitch
                visible: root.hasSwitch
                onClicked: root.switchToggled()
            }
        }

        Item {
            visible: !root.hasItems

            Layout.fillWidth: true
            implicitHeight: 60

            Text {
                id: placeholderText

                anchors.centerIn: parent

                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                color: Colors.md3.outline
            }
        }

        ListView {
            id: listView

            visible: root.hasItems

            Layout.fillWidth: true
            Layout.leftMargin: root.listLeftMargin
            Layout.rightMargin: root.listRightMargin

            implicitHeight: Math.min(contentHeight, 150)
            interactive: contentHeight > height

            spacing: Theme.spacingMedium
            clip: true

            Components.ScrollHint {
                listView: listView
                direction: "bottom"
            }
            Components.ScrollHint {
                listView: listView
                direction: "top"
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 1
            color: Colors.md3.surface_container_highest

            Layout.leftMargin: Theme.spacingSmall
            Layout.rightMargin: Theme.spacingSmall
        }

        Components.Button {
            id: footerButton
            text: "Settings"
            fontSize: Theme.fontSizeMedium

            backgroundColor: Colors.md3.surface_container_low
            backgroundOpacity: hovered ? 1 : 0

            onClicked: {
                ControlCenter.Controller.close();
                root.settingsRequested();
            }
        }
    }
}
