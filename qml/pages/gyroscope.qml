import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.0

Page {

    id: page
    property int x_value: 0
    property int y_value: 0
    property int z_value: 0
    property var values: [1000, -1000, 1000, -1000, 1000, -1000] //x_min, x_max, y_min, y_max, z_min, z_max
    property var x_average: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    property var y_average: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    property var z_average: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    property var abs_average: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    property int index: 0
    property int interv: 200

    function myCalc_avg(x_read, y_read, z_read) {
        page.x_average[index] = x_read
        page.y_average[index] = y_read
        page.z_average[index] = z_read
        abs_average[index] = Math.sqrt(Math.pow(x_read, 2) + Math.pow(y_read, 2) + Math.pow(z_read, 2))
        var sum_x = 0
        var sum_y = 0
        var sum_z = 0
        var sum_abs = 0

        for (var i = 0; i < 10; i++) {
            sum_x = sum_x + page.x_average[i]
            sum_y = sum_y + page.y_average[i]
            sum_z = sum_z + page.z_average[i]
            sum_abs = sum_abs + page.abs_average[i]
        }

        sum_x = 10 * Math.round(sum_x / 100)
        sum_y = 10 * Math.round(sum_y / 100)
        sum_z = 10 * Math.round(sum_z / 100)
        sum_abs = 10 * Math.round(sum_abs / 100)

        //console.log("Avg: " + sum)
        x_avg.text = sum_x
        y_avg.text = sum_y
        z_avg.text = sum_z
        absolute_value.text = sum_abs

        ikkuna.x_avg = sum_x
        ikkuna.y_avg = sum_y
        ikkuna.z_avg = sum_z
        ikkuna.abs_avg = sum_abs

        index++
        if (index == 10) {
            index = 0
        }
    }

    SilicaFlickable {
        contentHeight: column.height
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        VerticalScrollDecorator {}
        PullDownMenu {
            MenuItem {
                text: "Change interval to: 100"
                onClicked: page.interv = 100
            }
            MenuItem {
                text: "Change interval to: 200"
                onClicked: page.interv = 200
            }
            MenuItem {
                text: "Change interval to: 300"
                onClicked: page.interv = 300
            }
        }

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            id: column
            PageHeader {
                title: "Gyroscope"
            }
            Row {
                Button {
                    text: "Stop/Start"
                    onClicked: {
                        if (timer.running == true) {
                            timer.running = false
                        } else {
                            timer.running = true
                            //gyroscope.active = true
                        }
                    }
                }
                Button {
                    text: "Reset Grid"
                    onClicked: {
                        page.values = [1000, -1000, 1000, -1000, 1000, -1000]
                    }
                }
            }
            Row {
                id: row

                Button {
                    text: "Grid"
                    onClicked: {
                        if (grid.visible == false) {
                            grid.visible = true
                        } else {
                            grid.visible = false
                        }
                    }
                }
                Button {
                    text: "Show Raw data"
                    onClicked: {
                        if (x_reading.visible == false) {
                            x_reading.visible = true
                            y_reading.visible = true
                            z_reading.visible = true
                        } else {
                            x_reading.visible = false
                            y_reading.visible = false
                            z_reading.visible = false
                        }
                    }
                }
            }
            Column {
                id: numbers

                spacing: Theme.paddingLarge
                //anchors.centerIn: Theme.paddingLarge

                Timer {
                    id: timer
                    interval: page.interv
                    running: true
                    repeat: true
                    onTriggered: {
                        x_reading.text = "X: " + gyroscope.reading.x
                        y_reading.text = "Y: " + gyroscope.reading.y
                        z_reading.text = "Z: " + gyroscope.reading.z
                        //calibration_number.text = "Calibration level: " +gyroscope.reading.calibrationLevel
                        //console.log("Calibration level: ", gyroscope.reading.calibrationLevel)

                        page.x_value = gyroscope.reading.x
                        x_bar.value = page.x_value
                        x_bar.valueText = page.x_value
                        if (page.x_value < page.values[0]) {
                            page.values[0] = page.x_value
                            x_min.text = page.values[0]
                            //console.log("Found new x_min: " + x_min.text)
                        } else if (page.x_value > page.values[1]) {
                            page.values[1] = page.x_value
                            x_max.text = page.values[1]
                            //console.log("Found new x_max: " + x_max.text)
                        }

                        page.y_value = gyroscope.reading.y
                        y_bar.value = page.y_value
                        y_bar.valueText = page.y_value
                        if (page.y_value < page.values[2]) {
                            page.values[2] = page.y_value
                            y_min.text = page.values[2]
                        } else if (page.y_value > page.values[3]) {
                            page.values[3] = page.y_value
                            y_max.text = page.y_value
                        }

                        page.z_value = gyroscope.reading.z
                        z_bar.value = page.z_value
                        z_bar.valueText = page.z_value
                        if (page.z_value < page.values[4]) {
                            page.values[4] = page.z_value
                            z_min.text = page.z_value
                        } else if (page.z_value > page.values[5]) {
                            page.values[5] = page.z_value
                            z_max.text = page.z_value
                        }

                        page.myCalc_avg(page.x_value, page.y_value,
                                        page.z_value)

                    }
                }
                Gyroscope {
                    id: gyroscope
                    active: true
                }
                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: absolute_value
                    text: "Abs value: "
                }
                Label {
                    id: x_reading
                    text: "0"
                    color: Theme.highlightColor
                    visible: false
                }
                ProgressBar {
                    id: x_bar
                    minimumValue: -1000
                    maximumValue: 1000
                    value: 0
                    width: 500

                }
                Label {
                    id: y_reading
                    text: "0"
                    color: Theme.highlightColor
                    visible: false

                }
                ProgressBar {
                    id: y_bar
                    minimumValue: -1000
                    maximumValue: 1000
                    value: 0
                    width: 500
                }
                Label {
                    id: z_reading
                    text: "0"
                    color: Theme.highlightColor
                    visible: false

                }
                ProgressBar {
                    id: z_bar
                    minimumValue: -1000
                    maximumValue: 1000
                    value: 0
                    width: 500
                }
            }
            Grid {
                x: Theme.paddingLarge
                id: grid
                visible: false
                columns: 4
                spacing: Theme.paddingLarge
                //anchors.centerIn: parent
                Label {
                    text: " "
                    color: Theme.secondaryHighlightColor
                }
                Label {
                    text: "Min:"
                    color: Theme.secondaryHighlightColor
                }
                Label {
                    text: "Max:"
                    color: Theme.secondaryHighlightColor
                }
                Label {
                    text: "Cur. Avg."
                    color: Theme.secondaryHighlightColor
                }
                Label {
                    text: "X:"
                    color: Theme.secondaryHighlightColor
                }
                Label {
                    text: "0"
                    id: x_min
                }
                Label {
                    text: "0"
                    id: x_max
                }
                Label {
                    text: "0"
                    id: x_avg
                }
                Label {
                    text: "Y:"
                    color: Theme.secondaryHighlightColor
                }
                Label {
                    text: "0"
                    id: y_min
                }
                Label {
                    text: "0"
                    id: y_max
                }
                Label {
                    text: "0"
                    id: y_avg
                }
                Label {
                    text: "Z:"
                    color: Theme.secondaryHighlightColor
                }
                Label {
                    text: "0"
                    id: z_min
                }
                Label {
                    text: "0"
                    id: z_max
                }
                Label {
                    text: "0"
                    id: z_avg
                }
            }
        }
    }
}
