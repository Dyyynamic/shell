import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../utils"

Button {
    id: root

    property alias radius: background.radius

    property color backgroundColor: Colors.md3.surface_container_high
    property color hoveredColor: Theme.colorMix(backgroundColor, Colors.md3.on_surface, Theme.hoverIntensity);
    property color pressedColor: Theme.colorMix(backgroundColor, Colors.md3.on_surface, Theme.pressIntensity);
    property alias backgroundOpacity: background.opacity

    property alias textColor: textItem.color
    property alias fontWeight: textItem.font.weight
    property alias fontSize: textItem.font.pixelSize
    property alias textAlignment: textItem.horizontalAlignment

    property string iconGlyph: ""
    property alias iconSpacing: layout.spacing

    implicitHeight: 32
    horizontalPadding: Theme.spacingMedium

    hoverEnabled: enabled
    opacity: enabled > 0 ? 1 : 0.35

    background: Rectangle {
        id: background
        radius: height / 2

        color: {
            if (root.pressed)
                return root.pressedColor;
            if (root.hovered)
                return root.hoveredColor;
            return root.backgroundColor;
        }

        Behavior on color {
            ColorAnimation {
                duration: Theme.durationFast
                easing.type: Theme.easingStandard
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Theme.durationFast
                easing.type: Theme.easingStandard
            }
        }
    }

    contentItem: RowLayout {
        id: layout
        spacing: Theme.spacingTiny

        Icon {
            visible: root.iconGlyph !== ""
            id: icon
            icon: root.iconGlyph
        }

        Text {
            id: textItem
            text: root.text
            color: Colors.md3.on_surface
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
            font.weight: Font.Medium

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
        }
    }
}
