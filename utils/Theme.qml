pragma Singleton

import Quickshell
import QtQuick
import "../utils"

Singleton {
    id: root

    function colorMix(color1, color2, factor) {
        return Qt.tint(color1, Qt.rgba(color2.r, color2.g, color2.b, factor));
    }

    // Colors
    readonly property color base: Colors.md3.background

    readonly property color surface: colorMix(base, text, 0.035)
    readonly property color overlay: colorMix(base, text, 0.1)
    readonly property color overlayHigh: colorMix(base, text, 0.18)

    readonly property color outline: colorMix(base, text, 0.1)
    readonly property color divider: colorMix(base, text, 0.18)
    readonly property color dividerHigh: colorMix(base, text, 0.25)

    readonly property color accent: Colors.md3.primary
    readonly property color accentDark: colorMix(accent, base, 0.75)

    // Intensities
    readonly property real hoverIntensity: 0.05
    readonly property real pressIntensity: 0.1

    readonly property real accentHoverIntensity: 0.1
    readonly property real accentPressIntensity: 0.2

    // Text colors
    readonly property color text: Colors.md3.on_background
    readonly property color textVariant: colorMix(text, base, 0.2)
    readonly property color textDisabled: colorMix(text, base, 0.4)
    readonly property color textAccent: Colors.md3.on_primary

    // Font
    readonly property string fontFamily: "NotoSans Nerd Font Propo"
    readonly property int fontSize: 16
    readonly property int fontSizeSmall: 14
    readonly property int fontSizeTiny: 12

    // Animations
    readonly property int durationFast: 100        // Hover, press, fast fades
    readonly property int durationMedium: 200      // Standard slides and fades
    readonly property int durationSlideIn: 300     // Entering panels
    readonly property int durationAtmospheric: 400 // Lockscreen

    readonly property int easingStandard: Easing.OutCubic
    readonly property int easingExpressive: Easing.OutBack
    readonly property real overshoot: 0.7

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
