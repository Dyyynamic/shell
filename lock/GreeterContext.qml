import QtQuick
import Quickshell
import Quickshell.Services.Greetd

Scope {
    id: root
    signal greetdSuccess
    signal greetdFailure

    property string currentText: ""
    property bool isUnlocking: false
    property bool showFailure: false

    function tryUnlock(text) {
        if (text === "")
            return;

        root.currentText = text;
        root.isUnlocking = true;
        Greetd.createSession("dynamic");
    }

    Connections {
        target: Greetd

        function onAuthMessage(message: string, error: bool, responseRequired: bool, echoResponse: bool) {
            if (responseRequired) {
                Greetd.respond(root.currentText);
            }
        }

        function onAuthFailure() {
            root.currentText = "";
            root.showFailure = true;
            root.isUnlocking = false;
            root.greetdFailure();
        }

        function onReadyToLaunch() {
            root.isUnlocking = false;
            root.greetdSuccess();
        }
    }
}
