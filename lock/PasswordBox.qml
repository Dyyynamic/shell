import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import "../utils"

TextField {
    id: root

    required property var context

    Layout.alignment: Qt.AlignHCenter

    implicitWidth: 240
    implicitHeight: 40
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizeMedium
    color: "#e3e3e3"
    padding: Theme.spacingMedium

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    palette {
        highlight: Qt.alpha(Colors.md3.primary_fixed_dim, 0.5)
        highlightedText: "#e3e3e3"
    }

    background: Rectangle {
        color: Qt.alpha("#e3e3e3", 0.15)
        radius: height / 2
    }

    Text {
        anchors.fill: parent
        anchors.margins: root.padding

        text: root.text.length === 0 ? "Enter password" : ""
        color: "#e3e3e3"
        font: root.font

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    enabled: !root.context.isUnlocking

    echoMode: TextInput.Password
    inputMethodHints: Qt.ImhHiddenText

    Component.onCompleted: root.forceActiveFocus()

    onTextChanged: () => {
        if (text != "") {
            root.context.showFailure = false;
        }
    }

    onAccepted: () => {
        root.context.tryUnlock(text);
    }

    Connections {
        target: root.context

        function onFailure() {
            root.text = "";
        }
    }
}
