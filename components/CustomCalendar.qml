pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../utils"

ColumnLayout {
    id: root

    readonly property var locale: Qt.locale("sv_SE")
    readonly property date currentDate: new Date()

    spacing: 10

    function reset() {
        grid.month = root.currentDate.getMonth();
        grid.year = root.currentDate.getFullYear();
    }

    RowLayout {
        spacing: 10

        Text {
            text: Qt.formatDate(new Date(grid.year, grid.month), "MMMM yyyy")
            font.family: "NotoSans Nerd Font Propo"
            font.bold: true
            font.pixelSize: 16
            color: Colors.md3.on_background
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Item {
            Layout.fillWidth: true
        }

        IconButton {
            id: resetButton

            property bool shown: grid.month !== root.currentDate.getMonth() || grid.year !== root.currentDate.getFullYear()

            opacity: shown ? 1 : 0
            enabled: shown

            size: 32
            iconText: ""
            onClicked: root.reset()

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }

        IconButton {
            id: prevMonthButton

            size: 32
            iconText: ""
            onClicked: {
                grid.month = (grid.month - 1 + 12) % 12;
                grid.year = grid.year - (grid.month === 11 ? 1 : 0);
            }
        }

        IconButton {
            id: nextMonthButton

            size: 32
            iconText: ""
            onClicked: {
                grid.month = (grid.month + 1) % 12;
                grid.year = grid.year + (grid.month === 0 ? 1 : 0);
            }
        }
    }

    ColumnLayout {
        Layout.fillWidth: true

        DayOfWeekRow {
            Layout.fillWidth: true
            locale: root.locale
            implicitHeight: 32

            delegate: Text {
                required property var modelData

                text: {
                    let days = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];
                    return days[modelData.day];
                }
                font.family: "NotoSans Nerd Font Propo"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: Colors.md3.on_background
            }
        }

        MonthGrid {
            id: grid

            Layout.fillWidth: true
            locale: root.locale

            delegate: Item {
                id: dayItem

                required property var modelData

                implicitWidth: 32
                implicitHeight: 32

                Rectangle {
                    anchors.centerIn: parent
                    width: 32
                    height: 32
                    radius: 16

                    visible: dayItem.modelData.today
                    color: Colors.md3.primary
                }

                Text {
                    anchors.centerIn: parent
                    text: dayItem.modelData.day
                    font.family: "NotoSans Nerd Font Propo"

                    color: {
                        if (dayItem.modelData.today)
                            return Colors.md3.on_primary;
                        if (dayItem.modelData.month === grid.month)
                            return Colors.md3.on_background;
                        return Qt.darker(Colors.md3.on_background, 2);
                    }
                }
            }
        }
    }
}
