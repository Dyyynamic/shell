import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../utils"

ColumnLayout {
    id: calendar

    spacing: 10

    property var locale: Qt.locale("sv_SE")
    property date currentDate: new Date()

    RowLayout {
        spacing: 10

        Text {
            text: Qt.formatDate(calendar.currentDate, "MMMM yyyy")
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
            locale: calendar.locale
            implicitHeight: 32

            delegate: Text {
                text: {
                    let days = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];
                    return days[model.day];
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
            locale: calendar.locale

            delegate: Item {
                implicitWidth: 32
                implicitHeight: 32

                Rectangle {
                    anchors.centerIn: parent
                    width: 32
                    height: 32
                    radius: 16

                    visible: model.today
                    color: Colors.md3.primary
                }

                Text {
                    anchors.centerIn: parent
                    text: model.day
                    font.family: "NotoSans Nerd Font Propo"

                    color: {
                        if (model.today)
                            return Colors.md3.on_primary;
                        if (model.month === grid.month)
                            return Colors.md3.on_background;
                        return Qt.darker(Colors.md3.on_background, 2);
                    }
                }
            }
        }
    }
}
