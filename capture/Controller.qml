pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "." as Capture
import "../utils"

Singleton {
    id: root

    enum CaptureType {
        Screenshot,
        Record
    }

    enum CaptureMode {
        Region,
        Screen
    }

    property bool overlayLoaded: false
    property bool overlayVisible: false
    property bool overlayInteractive: false

    property alias isRecording: recorderProcess.running
    property int recordingDuration: 0
    property var recordingNotifProc: null

    property int captureType: 0
    property int captureMode: 0

    readonly property string screenshotDir: Quickshell.env("HOME") + "/Pictures/Screenshots"
    readonly property string recordingDir: Quickshell.env("HOME") + "/Videos/Recordings"
    readonly property string thumbnailDir: "/tmp/screenshots"

    function openOverlay() {
        overlayLoaded = true;
        overlayVisible = true;
        overlayInteractive = true;
    }

    function closeOverlay() {
        overlayVisible = false;
        overlayInteractive = false;
    }

    function openPath(path) {
        openProcess.command = ["xdg-open", path];
        openProcess.running = true;
    }

    function copyFile(file) {
        copyProcess.command = ["sh", "-c", `cat "${file}" | wl-copy`];
        copyProcess.running = true;
    }

    function createThumbnail(inputPath, outputPath) {
        const thumbnailProcess = thumbnailProcComponent.createObject();
        thumbnailProcess.thumbnailPath = outputPath;
        thumbnailProcess.filePath = inputPath;
        thumbnailProcess.command = ["magick", inputPath, "-thumbnail", "250x250", outputPath];
        thumbnailProcess.running = true;
    }

    function timestamp() {
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, "0");
        const day = String(now.getDate()).padStart(2, "0");
        const hours = String(now.getHours()).padStart(2, "0");
        const minutes = String(now.getMinutes()).padStart(2, "0");
        const seconds = String(now.getSeconds()).padStart(2, "0");
        const milliseconds = String(now.getMilliseconds()).padStart(3, "0");

        const date = [year, month, day].join("-");
        const time = [hours, minutes, seconds + "." + milliseconds].join("-");

        return [date, time].join(" ");
    }

    function takeScreenshot(region) {
        const filePath = screenshotDir + "/" + timestamp() + ".png";
        const thumbnailPath = thumbnailDir + "/thumb_" + timestamp() + ".png";

        // Take screenshot
        const screenshotProcess = screenshotProcComponent.createObject();
        const command = ["grim", "-g", `${region.x},${region.y} ${region.width}x${region.height}`, filePath];
        screenshotProcess.filePath = filePath;
        screenshotProcess.thumbnailPath = thumbnailPath;
        screenshotProcess.command = command;
        screenshotProcess.running = true;
    }

    function startRecording(region) {
        // Start timer
        recordingDuration = 0;
        recordTimer.running = true;

        // Start recording
        const filePath = recordingDir + "/" + timestamp() + ".mp4";
        const audio = Audio.defaultSink.name + ".monitor";
        const command = ["wf-recorder", "-g", `${region.x},${region.y} ${region.width}x${region.height}`, "-f", filePath, "-a=" + audio];
        recorderProcess.filePath = filePath;
        recorderProcess.command = command;
        recorderProcess.running = true;

        recordingNotifProc = Notifications.send("Recording started", "Click to stop", {
            actions: {
                default: {
                    text: "Stop Recording",
                    callback: () => stopRecording()
                }
            }
        });
    }

    function stopRecording() {
        // Stop timer
        recordTimer.running = false;
        recordingDuration = 0;

        // Stop recording
        recorderProcess.running = false;

        // Dismiss recording started notification
        if (recordingNotifProc?.id !== -1)
            Notifications.dismiss(recordingNotifProc.id);
        recordingNotifProc = null;

        closeOverlay();
    }

    function request(type, mode) {
        if (overlayLoaded) {
            closeOverlay();
            return;
        }

        if (isRecording) {
            // Stop recording if trying to record while already recording
            if (type === Controller.CaptureType.Record)
                stopRecording();
            return;
        }

        captureType = type;
        captureMode = mode;

        if (mode === Controller.CaptureMode.Region)
            openOverlay();
        else if (mode === Controller.CaptureMode.Screen) {
            const monitor = Hyprland.focusedMonitor;
            const region = Qt.rect(monitor.x, monitor.y, monitor.width, monitor.height);

            if (type === Controller.CaptureType.Screenshot)
                takeScreenshot(region);
            else if (type === Controller.CaptureType.Record)
                startRecording(region);
        }
    }

    IpcHandler {
        target: "capture"

        function screenshot(target: string) {
            root.request(Controller.CaptureType.Screenshot, target === "region" ? Controller.CaptureMode.Region : Controller.CaptureMode.Screen);
        }

        function record(target: string) {
            root.request(Controller.CaptureType.Record, target === "region" ? Controller.CaptureMode.Region : Controller.CaptureMode.Screen);
        }

        function stop() {
            root.stopRecording();
        }
    }

    LazyLoader {
        active: root.overlayLoaded

        Capture.Overlay {
            controller: root
            inputEnabled: root.overlayInteractive

            onRegionSelected: region => {
                if (root.captureType === Controller.CaptureType.Screenshot) {
                    // Close the select before taking the screenshot
                    root.closeOverlay();
                    root.takeScreenshot(region);
                } else if (root.captureType === Controller.CaptureType.Record) {
                    // Keep select open while recording
                    root.overlayInteractive = false;
                    root.startRecording(region);
                }
            }
        }
    }

    Process {
        id: recorderProcess

        property string filePath

        onExited: {
            Notifications.send("Recording stopped", "Video saved to " + filePath, {
                actions: {
                    default: {
                        text: "Open",
                        callback: () => root.openPath(root.recordingDir)
                    }
                }
            });
        }
    }

    Component {
        id: screenshotProcComponent

        Process {
            property string filePath
            property string thumbnailPath

            onExited: {
                // Create thumbnail first, then show notification
                root.createThumbnail(filePath, thumbnailPath);
            }
        }
    }

    Component {
        id: thumbnailProcComponent

        Process {
            property string thumbnailPath
            property string filePath

            onExited: {
                // Copy file to clipboard
                root.copyFile(filePath);

                // Show notification after thumbnail is created
                Notifications.send("Screenshot saved", "Image saved to " + filePath, {
                    icon: thumbnailPath,
                    actions: {
                        default: {
                            text: "Open",
                            callback: () => root.openPath(root.screenshotDir)
                        }
                    }
                });
            }
        }
    }

    Process {
        id: openProcess
    }

    Process {
        id: copyProcess
    }

    Process {
        // Create directories ahead of time
        command: ["mkdir", "-p", root.screenshotDir, root.recordingDir, root.thumbnailDir]
        running: true
    }

    Timer {
        id: recordTimer
        interval: 1000
        running: false
        repeat: true
        onTriggered: root.recordingDuration++
    }

    // Empty function to define first reference to singleton
    function init() {
    }
}
