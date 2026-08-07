import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: root

    property var network

    ColumnLayout {
        Text {
            text: "Connect to " + root.network?.ssid
        }

        TextField {
            id: passwordField
            placeholderText: "Password"
            echoMode: TextInput.Password
        }

        Button {
            text: "Connect"

            onClicked: {
                root.network.connectWithPsk(passwordField.text)

                root.close()
            }
        }
    }
}
