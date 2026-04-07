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
            font.bold: true
            font.pixelSize: 16
            color: Colors.md3.on_background
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Item {
            Layout.fillWidth: true
        }

        Button {
            id: prevMonthButton

            implicitWidth: 32
            implicitHeight: 32
            text: ""
            onClicked: {
                grid.month = (grid.month - 1 + 12) % 12;
                grid.year = grid.year - (grid.month === 11 ? 1 : 0);
            }

            background: Rectangle {
                anchors.fill: parent
                radius: 16
                color: {
                    if (prevMonthButton.pressed) {
                        Qt.lighter(Colors.md3.background, 3);
                    } else {
                        if (prevMonthButton.hovered) {
                            Qt.lighter(Colors.md3.background, 2.5);
                        } else {
                            Qt.lighter(Colors.md3.background, 2);
                        }
                    }
                }
            }
        }

        Button {
            id: nextMonthButton

            implicitWidth: 32
            implicitHeight: 32
            text: ""
            onClicked: {
                grid.month = (grid.month + 1) % 12;
                grid.year = grid.year + (grid.month === 0 ? 1 : 0);
            }

            background: Rectangle {
                anchors.fill: parent
                radius: 16
                color: {
                    if (nextMonthButton.pressed) {
                        Qt.lighter(Colors.md3.background, 3);
                    } else {
                        if (nextMonthButton.hovered) {
                            Qt.lighter(Colors.md3.background, 2.5);
                        } else {
                            Qt.lighter(Colors.md3.background, 2);
                        }
                    }
                }
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

                    color: model.today ? Colors.md3.on_primary : model.month === grid.month ? Colors.md3.on_background : Qt.darker(Colors.md3.on_background, 2)
                }
            }
        }
    }
}
