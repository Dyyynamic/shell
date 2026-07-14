pragma Singleton

import Quickshell
import QtQuick
import "../utils"

Singleton {
    id: root

    // Colors
    readonly property color base: Colors.md3.background

    readonly property color surface: Qt.lighter(base, 1.35)
    readonly property color overlay: Qt.lighter(base, 2)
    readonly property color overlayHigh: Qt.lighter(base, 2.5)

    readonly property color accent: Colors.md3.primary
    readonly property color outline: Qt.lighter(base, 2)

    // Multipliers
    readonly property real hoverMultiplier: 1.25
    readonly property real pressedMultiplier: 1.5

    readonly property real accentHoverMultiplier: 1.1
    readonly property real accentPressedMultiplier: 1.2

    // Text colors
    readonly property color text: Colors.md3.on_background
    readonly property color textSecondary: Qt.darker(Colors.md3.on_background, 2)
    readonly property color textAccent: Colors.md3.on_primary

    // Font
    readonly property string fontFamily: "NotoSans Nerd Font Propo"
    readonly property int fontSize: 16
    readonly property int fontSizeSmall: 14
    readonly property int fontSizeTiny: 12
}
