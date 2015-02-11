import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.0
Page {
    id: page
    property int acc_x_value: 0
    property int acc_y_value: 0
    property int acc_z_value: 0

    property int mag_x_value: 0
    property int mag_y_value: 0
    property int mag_z_value: 0
    Accelerometer {
        id: accelerometer
        active: false
    }
    Magnetometer {
        id: magnetometer
        active: false
    }

    onStatusChanged: {
        if(ikkuna.canvas_mode === 0) {
            accel_timer.running = true
            accelerometer.active = true
        }
        else if(ikkuna.canvas_mode === 1) {
            magnetic_timer.running = true
            magnetometer.active = true
        }
        else {
            console.log("ERROR with canvas_mode")
        }
    }

    Timer {
        id: accel_timer
        interval: 200
        running: false
        repeat: true
        onTriggered: {
            page.acc_x_value = accelerometer.reading.x * 50
            page.acc_y_value = accelerometer.reading.y * 50
            page.acc_z_value = accelerometer.reading.z * 50
            canvas.draw_new()
        }
    }
    Timer {
        id: magnetic_timer
        interval: 500
        running: false
        repeat: true
        onTriggered: {
            page.mag_x_value = magnetometer.reading.x * 10000000
            page.mag_y_value = magnetometer.reading.y * 10000000
            page.mag_z_value = magnetometer.reading.z * 10000000
            canvas.draw_new()
            console.log("X: %d Y: %d", page.mag_x_value, page.mag_y_value)
            console.log("Absolute value: ", Math.sqrt(Math.pow(page.mag_x_value, 2) + Math.pow(page.mag_y_value, 2) + Math.pow(page.mag_z_value, 2)))
        }
    }
    Canvas {
        //anchors.centerIn: parent
        //anchors.horizontalCenterOffset: (parent.width)/2
        id: canvas
        property var ctx
        width: parent.width
        height: parent.height
        function draw_new() {
            canvas.requestPaint()
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(timer.running === true) {
                    timer.running = false
                }
                else {
                    timer.running = true
                    canvas.ctx.reset()
                }
            }
            onPressAndHold: {
                pageStack.push(Qt.resolvedUrl("canvas_settings.qml"))
            }
        }

        onPaint: {
            // setup the stroke
            canvas.ctx = getContext("2d")

            if(ikkuna.canvas_clear === 1) {
                canvas.ctx.reset()
            }
            var width = parent.width
            var height = parent.height
            var gradient
            if(ikkuna.canvas_mode === 0) {
                //Accelerometer
                gradient = ctx.createLinearGradient(width/2, height/2, (width/2)-page.acc_x_value, (height/2)+page.acc_y_value)

            }
            else if(ikkuna.canvas_mode === 1) {
                //Magnetometer
                gradient = ctx.createLinearGradient(width/2, height/2, (width/2)-page.mag_x_value, (height/2)+page.mag_y_value)
            }
            gradient.addColorStop(0, "purple")
            gradient.addColorStop(0.15, "blue")
            gradient.addColorStop(0.30, "cyan")
            gradient.addColorStop(0.45, "green")
            gradient.addColorStop(0.60, "yellow")
            gradient.addColorStop(0.75, "orange")
            gradient.addColorStop(0.9, "red")

            canvas.ctx.lineWidth = 5
            canvas.ctx.strokeStyle = gradient

            canvas.ctx.moveTo(width/2, height/2)

            // Check which mode it is
            if(ikkuna.canvas_mode === 0) {
                //accelerometer
                canvas.ctx.lineTo((width/2)-page.acc_x_value, (height/2)+page.acc_y_value)
            }
            else if(ikkuna.canvas_mode === 1) {
                //magnetometer
                canvas.ctx.lineTo((width/2)+page.mag_x_value, (height/2)-page.mag_y_value)
            }
            canvas.ctx.stroke()
        }
    }
}
