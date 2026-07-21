pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    Process {
        running: true
        onRunningChanged: if (!running)
            running = true

        command: ["sh", "-c", "'cat", "/sys/class/leds/input*::capslock/brightness'"]

        stdout: StdioCollector {
            onStreamFinished: console.log(this.text)
        }
    }
}
