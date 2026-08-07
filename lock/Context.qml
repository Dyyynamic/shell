import QtQuick
import Quickshell
import Quickshell.Services.Pam

Scope {
    id: root
    signal success
    signal failure

    property string currentText: ""
    property bool isUnlocking: false
    property bool showFailure: false
    property bool animate: true

    // Clear the failure text once the user starts typing
    onCurrentTextChanged: showFailure = false

    function tryUnlock(text) {
        if (text === "")
            return;

        root.currentText = text;
        root.isUnlocking = true;
        pam.start();
    }

    PamContext {
        id: pam

        onPamMessage: {
            if (this.responseRequired) {
                this.respond(root.currentText);
            }
        }

        onCompleted: result => {
            if (result == PamResult.Success) {
                root.success();
            } else {
                root.currentText = "";
                root.showFailure = true;
                root.failure();
            }

            root.isUnlocking = false;
        }
    }
}
