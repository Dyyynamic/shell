pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import "../utils"

Singleton {
    id: root

    function colorMix(color1, color2, factor) {
        return Qt.tint(color1, Qt.rgba(color2.r, color2.g, color2.b, factor));
    }

    function toggleDarkMode() {
        mode = mode === "dark" ? "light" : "dark";
        matugen.running = true;
    }

    readonly property string wallpaper: Colors.wallpaper
    property string mode: Colors.mode

    // Intensities
    readonly property real hoverIntensity: 0.08
    readonly property real pressIntensity: 0.12

    // Font
    readonly property string fontFamily: "NotoSans Nerd Font Propo"
    readonly property int fontSizeExtraLarge: 24
    readonly property int fontSizeLarge: 16
    readonly property int fontSizeMedium: 14
    readonly property int fontSizeSmall: 12
    readonly property int fontSizeTiny: 11

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
    readonly property int spacingExtraLarge: 32
    readonly property int spacingLarge: 16
    readonly property int spacingMedium: 12
    readonly property int spacingSmall: 8
    readonly property int spacingTiny: 4

    Process {
        id: matugen
        command: ["matugen", "image", root.wallpaper, "--mode", root.mode, "--source-color-index", "0"]
    }
}
