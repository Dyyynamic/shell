pragma Singleton

import Quickshell
import QtQuick
import "../utils"

Singleton {
    id: root

    function colorMix(color1, color2, factor) {
        return Qt.tint(color1, Qt.rgba(color2.r, color2.g, color2.b, factor))
    }

    // Colors
    readonly property color base: Colors.md3.background

    readonly property color surface: colorMix(base, text, 0.035)
    readonly property color overlay: colorMix(base, text, 0.1)
    readonly property color overlayHigh: colorMix(base, text, 0.25)

    readonly property color accent: Colors.md3.primary
    readonly property color accentDark: colorMix(accent, base, 0.75)
    readonly property color outline: colorMix(base, text, 0.1)

    // Multipliers
    readonly property real hoverMult: 1.25
    readonly property real pressMult: 1.5

    readonly property real accentHoverMult: 1.05
    readonly property real accentPressMult: 1.1

    // Text colors
    readonly property color text: Colors.md3.on_background
    readonly property color textSecondary: colorMix(text, base, 0.45)
    readonly property color textAccent: Colors.md3.on_primary

    // Font
    readonly property string fontFamily: "NotoSans Nerd Font Propo"
    readonly property int fontSize: 16
    readonly property int fontSizeSmall: 14
    readonly property int fontSizeTiny: 12

    // Animations
    readonly property int animDurationLong: 400
    readonly property int animDurationMedium: 200
    readonly property int animDurationShort: 100
    readonly property int animEasing: Easing.OutCubic

    // Radii
    readonly property int radiusLarge: 20
    readonly property int radiusMedium: 16
    readonly property int radiusSmall: 12
    readonly property int radiusTiny: 8

    // Spacing
    readonly property int spacingLarge: 16
    readonly property int spacingMedium: 12
    readonly property int spacingSmall: 8
    readonly property int spacingTiny: 4
}
