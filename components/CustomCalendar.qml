pragma ComponentBehavior: Bound

import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../utils"

Widget {
    id: root

    readonly property var locale: Qt.locale("sv_SE")
    readonly property date currentDate: new Date()

    function reset() {
        grid.month = root.currentDate.getMonth();
        grid.year = root.currentDate.getFullYear();
    }

    ColumnLayout {
        spacing: Theme.spacingSmall

        RowLayout {
            spacing: Theme.spacingSmall

            WrapperItem {
                margin: Theme.spacingSmall

                Text {
                    text: Qt.formatDate(new Date(grid.year, grid.month), "MMMM yyyy")
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    font.bold: true
                    color: Theme.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
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
                        duration: Theme.animationDuration
                        easing.type: Theme.animationEasing
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
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeTiny
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: Theme.text
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
                        radius: height / 2

                        visible: dayItem.modelData.today
                        color: Theme.accent
                    }

                    Text {
                        anchors.centerIn: parent
                        text: dayItem.modelData.day
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeTiny

                        color: {
                            if (dayItem.modelData.today)
                                return Theme.textAccent;
                            if (dayItem.modelData.month === grid.month)
                                return Theme.text;
                            return Theme.textSecondary;
                        }
                    }
                }
            }
        }
    }
}
