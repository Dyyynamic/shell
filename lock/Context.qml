import QtQuick
import Quickshell
import Quickshell.Services.Pam

Scope {
    id: root
    signal pamSuccess
    signal pamFailure

    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false

    // Clear the failure text once the user starts typing
    onCurrentTextChanged: showFailure = false

    function tryUnlock(text) {
        if (text === "")
            return;

        root.currentText = text;
        root.unlockInProgress = true;
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
                root.pamSuccess();
            } else {
                root.currentText = "";
                root.showFailure = true;
                root.pamFailure();
            }

            root.unlockInProgress = false;
        }
    }
}
