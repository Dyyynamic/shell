pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "." as WallpaperPicker

Singleton {
    id: root
    property bool isOpen: false
    property bool isTransitioning: false

    property var wallpapers: []
    property int currentIndex: -1

    readonly property string thumbnailDir: "/tmp/wallpapers"

    function open() {
        root.isTransitioning = true;
        // root.isOpen = true;

        findProcess.running = true;
    }

    function close() {
        if (!root.isOpen)
            return;

        root.isTransitioning = true;
        root.isOpen = false;
    }

    function toggle() {
        root.isOpen ? close() : open();
    }

    IpcHandler {
        target: "wallpaperPicker"

        function open() {
            root.open();
        }

        function close() {
            root.close();
        }

        function toggle() {
            root.toggle();
        }
    }

    LazyLoader {
        id: loader
        active: root.isOpen || root.isTransitioning

        WallpaperPicker.Overlay {}
    }

    Process {
        id: findProcess

        command: ["find", `${Quickshell.env("HOME")}/Pictures/Wallpapers`, "-maxdepth", "1", "-type", "f"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.wallpapers = text.trim().split("\n").filter(Boolean);

                // Find index of current wallpaper
                indexProcess.running = true;

                // Generate thumbnails for each wallpaper
                for (const wallpaper of root.wallpapers) {
                    const filename = wallpaper.split("/").pop();
                    const outputPath = root.thumbnailDir + "/" + filename;

                    const thumbnail = thumbnailComponent.createObject(root, {
                        inputPath: wallpaper,
                        outputPath: outputPath,
                    });
                }
            }
        }
    }

    Component {
        id: thumbnailComponent

        Scope {
            id: thumbnailObject

            property string inputPath
            property string outputPath

            FileView {
                id: fileView
                path: thumbnailObject.outputPath

                onLoadFailed: {
                    generateProcess.running = true;
                }
            }

            Process {
                id: generateProcess

                command: [
                    "magick",
                    thumbnailObject.inputPath,
                    "-thumbnail", "250x250",
                    thumbnailObject.outputPath
                ]
            }
        }
    }

    Process {
        id: testProcess
    }

    Process {
        // Create directory ahead of time
        command: ["mkdir", "-p", root.thumbnailDir]
        running: true
    }

    Process {
        id: indexProcess

        command: ["awww", "query", "-j"]

        stdout: StdioCollector {
            onStreamFinished: {
                const json = JSON.parse(text)
                const wallpaper = json[""][0].displaying.image
                const index = WallpaperPicker.Controller.wallpapers.indexOf(wallpaper)

                root.currentIndex = index
                root.isOpen = true;
            }
        }
    }

    function init() {
    }
}
