import QtQuick 2.0
import QtQuick.Particles 2.0
import Sailfish.Silica 1.0
import QtSensors 5.0

Page {
    property int wl_mag: 50
    property int wl_rate: 110
    property int wl_acc: 200
    property int mag_dir: 10
    id: root
    Component.onCompleted: {
        //console.log("Page entered, desired animation: ", ikkuna.particle_animation)

        if(ikkuna.particle_animation === 2) {

            // Starstorm settings

            chaotic_timer.running = true

            particle.colorVariation = 1
            particle.color = "#000000"
            particle.alpha = 1
            particle.alphaVariation = 1
            particle.source = "qrc:///new/prefix1/tahti.png"
            particle.entryEffect = ImageParticle.Scale

            middle_emitter.size = 32
            middle_emitter.endSize = 64
            middle_emitter.sizeVariation = 0
            middle_emitter.emitRate = 50
            middle_emitter.width = root.width/4
            middle_emitter.lifeSpan = 3000
            middle_emitter.x = parent.width/2
            middle_emitter.y = parent.width/2

            rect.color = "#000000"
            main_source.angle = 0
            main_source.angleVariation = 360
            main_source.magnitude = 100
            main_source.magnitudeVariation = 50

            side_emitter.emitRate = 100
            side_emitter.width = root.width
            side_emitter.height = root.height
            side_emitter.emitRate = 100
            side_emitter.lifeSpan = 400
            side_emitter.lifeSpanVariation = 2000
            side_emitter.size = 24
            side_emitter.endSize = 32

            affector_tur.width = root.width
            affector_tur.height = root.height
            affector_tur.strength = 100
        }

        else if(ikkuna.particle_animation === 1) {

            //Snowfall settings

            particle.colorVariation = 0
            particle.color = "#ffffff"
            particle.alpha = 1
            particle.alphaVariation = 0
            particle.source = "qrc:///new/prefix1/hiutale.png"
            particle.entryEffect = ImageParticle.Scale
            particle.rotationVariation = 45
            particle.rotationVelocityVariation = 15
            particle.rotationVelocity = 5

            middle_emitter.size = 40
            middle_emitter.endSize = 40
            middle_emitter.sizeVariation = 0
            middle_emitter.emitRate = 20
            middle_emitter.width = root.width
            middle_emitter.lifeSpan = 300000
            middle_emitter.x = 0
            middle_emitter.y = 0

            side_emitter.emitRate = 0

            rect.color = "#999999"

            main_source.angle = 90
            main_source.angleVariation = 10
            main_source.magnitude = 50
            main_source.magnitudeVariation = 20

            /*affector_tur.width = root.width
            affector_tur.height = root.height
            affector_tur.strength = 50*/
        }

        if(ikkuna.particle_animation === 0) {

            // Waterleak settings

            accelerometer.active = true

            waterleak_timer.running = true

            particle.colorVariation = 0
            particle.blueVariation = 1
            particle.color = "#330099"
            particle.alpha = 1
            particle.alphaVariation = 1
            particle.source = "qrc:///new/prefix1/pisara.png"
            particle.entryEffect = ImageParticle.None

            middle_emitter.size = 30
            middle_emitter.endSize = 0
            middle_emitter.sizeVariation = 0
            middle_emitter.emitRate = 0
            middle_emitter.width = 10
            middle_emitter.height = 10
            middle_emitter.lifeSpan = 3000
            middle_emitter.x = parent.width/2
            middle_emitter.y = parent.height/2

            rect.color = "#000000"
            main_source.angle = 0
            main_source.angleVariation = 10
            //main_source.magnitude = root.wl_mag
            main_source.magnitude = 0
            main_source.magnitudeVariation = 50

            main_acceleration.magnitude = root.wl_acc

            side_emitter.emitRate = 0

            affector_grav.width = root.width*2
            affector_grav.height = root.height*2
            affector_grav.x = -root.width
            affector_grav.y = -root.height
        }

        if(ikkuna.particle_animation === 3) {

            //Magnetic field settings

            magnetometer.active = true

            magnetic_timer.running = true

            rect.color = "#000000"

            particle.colorVariation = 0
            particle.blueVariation = 1
            particle.color = "#3300FF"
            particle.alpha = 1
            particle.alphaVariation = 1
            particle.source = "qrc:///new/prefix1/pisara.png"
            particle.entryEffect = ImageParticle.None

            middle_emitter.width = root.width
            middle_emitter.height = root.height
            middle_emitter.emitRate = 100
            middle_emitter.lifeSpan = 5000

            main_source.magnitude = 100
            main_source.angle = 0

            affector_grav.magnitude = 100

        }

        // When the pagestatus changes, enable storm if it has been enabled in settings
        if(ikkuna.storm === true) {
            affector_tur.strength = ikkuna.storm_str
            console.log("Page loaded, storm is enabled")
        }
        else if(ikkuna.storm === false){
            affector_tur.strength = 0
            console.log("Page loaded, storm is disabled")
        }
        else {
            console.log("Ikkuna.storm not properly set")
        }

    }
    // Accelerometer used to get readings for direction of waterflow in waterleak demo
    Accelerometer {
        id: accelerometer
        active: false
    }
    Magnetometer {
        id: magnetometer
        active: false
    }

    // Timer changing magnitude and emitrate in starstrom demo
    Timer {
        id: chaotic_timer
        interval: 400
        repeat: true
        running: false
        onTriggered: {
            main_source.magnitude += root.mag_dir
            middle_emitter.emitRate += root.mag_dir
            if(middle_emitter.emitRate > 170) {
                root.mag_dir = -root.mag_dir
            }
            else if(middle_emitter.emitRate == 0) {
                root.mag_dir = -root.mag_dir
            }
            //console.log("Magnitude and emitrate: ", main_source.magnitude, middle_emitter.emitRate)
        }
    }
    // Timer to calculate direction, magnitude, acceleration and emitrate in waterleak demo
    Timer {
        id: waterleak_timer
        interval: 50
        repeat: true
        running: false
        onTriggered: {
            var x = -accelerometer.reading.x
            var y = accelerometer.reading.y
            var z = accelerometer.reading.z

            var deg_angle
            var rad_angle

            //Calculate which direction particles are going
            if(x > 0 && y > 0) {
                rad_angle = Math.atan2(y, x)
                deg_angle = ((rad_angle/(2*Math.PI))*360)
                //main_source.angle = deg_angle
                main_acceleration.angle = deg_angle
                affector_grav.angle = deg_angle
                //console.log("Angle, x, y, atan", deg_angle, x, y, rad_angle)
            }
            else if(x > 0 && y < 0) {
                rad_angle = Math.atan2(y, x) + 2*Math.PI
                deg_angle = ((rad_angle/(2*Math.PI))*360)
                //main_source.angle = deg_angle
                main_acceleration.angle = deg_angle
                affector_grav.angle = deg_angle
                //console.log("Angle, x, y, atan", deg_angle, x, y, rad_angle)
            }
            else if(x < 0) {
                rad_angle = Math.atan2(y, x)
                deg_angle = ((rad_angle/(2*Math.PI))*360)
                //main_source.angle = deg_angle
                main_acceleration.angle = deg_angle
                affector_grav.angle = deg_angle
                //console.log("Angle, x, y, atan", deg_angle, x, y, rad_angle)
            }
            else {
                //console.log("Undefined x and y combination:", x, y)
            }

            //Calculate new emitrate
            var max = Math.sqrt(x*x + y*y)
            if(max > 10) { max = 10 }

            var new_rate = Math.round((max/10) * root.wl_rate)
            if(new_rate<0) {
                middle_emitter.emitRate = 0
            }
            else {
                middle_emitter.emitRate = new_rate
            }

            /*var new_mag = Math.round((max/10) * root.wl_mag)
            if (new_mag < 0) { main_source.magnitude = 0 }
            else { main_source.magnitude = new_mag }*/

            //Calculate new accelerations. They are magnitudes of accelerator components
            var new_acc = Math.round((max/10) * root.wl_acc)
            if(new_acc < 0) {
                main_acceleration.magnitude = 0
                affector_grav.magnitude = 0
            }
            else {
                main_acceleration.magnitude =(new_acc/3)*2
                affector_grav.magnitude = (new_acc/3)*4
            }

            //Calculate end size depending on the z-axis, trying to create illusion of 3d
            var endsize = 30-(Math.round(z)*3)
            middle_emitter.endSize = endsize
            //var lifespan = 11000-Math.round(z)*1000
            //middle_emitter.lifeSpan = lifespan
            //console.log("New endsize: ", endsize)
            //console.log("Lifespan: ", lifespan)


            //console.log("Rate, magnitude, acceleration: ", middle_emitter.emitRate, main_source.magnitude, main_acceleration.magnitude)
        }
    }


    Timer {
        id: magnetic_timer
        interval: 1000
        repeat: true
        running: false
        onTriggered: {
            var x = magnetometer.reading.x * 10000000
            var y = -magnetometer.reading.y * 10000000
            var z = magnetometer.reading.z * 10000000
            var abs_value = Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2) + Math.pow(z, 2))

            var deg_angle
            var rad_angle

            if(x > 0 && y > 0) {
                rad_angle = Math.atan2(y, x)
                deg_angle = ((rad_angle/(2*Math.PI))*360)
                main_source.angle = deg_angle
                //main_acceleration.angle = deg_angle
                affector_grav.angle = deg_angle
                console.log("Angle, x, y, z", deg_angle, x, y, z)
            }
            else if(x > 0 && y < 0) {
                rad_angle = Math.atan2(y, x) + 2*Math.PI
                deg_angle = ((rad_angle/(2*Math.PI))*360)
                main_source.angle = deg_angle
                //main_acceleration.angle = deg_angle
                affector_grav.angle = deg_angle
                console.log("Angle, x, y, z", deg_angle, x, y, z)
            }
            else if(x < 0) {
                rad_angle = Math.atan2(y, x)
                deg_angle = ((rad_angle/(2*Math.PI))*360)
                main_source.angle = deg_angle
                //main_acceleration.angle = deg_angle
                affector_grav.angle = deg_angle
                console.log("Angle, x, y, z", deg_angle, x, y, z)
            }
            else {
                console.log("Undefined x and y combination:", x, y)
            }
            if(abs_value < 380 || abs_value > 550 || z > x || z > y) {
                particle.color = "#00FF00"
            }
            else {
                particle.color = "#3300FF"
            }
            console.log("Absolute value: ", abs_value )
        }
    }

    // This dialog is not used. Could use this, if we found way to make it transparent, so that the demo would be running on back
    /*Dialog {
        id: dialog
        opacity: 1
        Column {
            anchors.centerIn: parent
            Button {
                text: "Add friction"
                onClicked: {
                    dialog.close()
                    affector_fric.factor = ikkuna.particle_fric
                    affector_fric.width = root.width
                    affector_fric.height = root.height
                }
            }
            Button {
                text: "Remove friction"
                onClicked: {
                    affector_fric.factor = 0
                    dialog.close()
                }
            }
        }
    }*/

    // Everything is under this
    SilicaFlickable {
        contentHeight: parent.height
        contentWidth: parent.width
        anchors.fill: parent
        // Menu for going into settings. Its commented out, user can enter the settings with a press_and_hold
        /*PullDownMenu {
            MenuItem {
                text: "Inf lifespan, max emitted limited"
                onClicked: {
                    middle_emitter.maximumEmitted = 1000
                    middle_emitter.lifeSpan = Emitter.InfiniteLife
                    particle.entryEffect = ImageParticle.None
                }
            }
            MenuItem {
                text: "Settings"
                onClicked: { pageStack.push(Qt.resolvedUrl("particle_settings.qml")) }
            }

        }*/
        // Menu for selecting which demo to show
        PushUpMenu {
            MenuItem {
                text: "Starstorm"
                onClicked: {
                    ikkuna.particle_animation = 2
                    pageStack.pop(null, PageStackAction.Immediate)
                    pageStack.push(Qt.resolvedUrl("particle.qml"), null, PageStackAction.Immediate)
                }
            }
            MenuItem {
                text: "Snowfall"
                onClicked: {
                    ikkuna.particle_animation = 1
                    pageStack.pop(null, PageStackAction.Immediate)
                    pageStack.push(Qt.resolvedUrl("particle.qml"), null, PageStackAction.Immediate)
                }
            }
            MenuItem {
                text: "Waterleak"
                onClicked: {
                    ikkuna.particle_animation = 0
                    pageStack.pop(null, PageStackAction.Immediate)
                    pageStack.push(Qt.resolvedUrl("particle.qml"), null, PageStackAction.Immediate)
                }
            }
            MenuItem {
                text: "Magnetic field"
                onClicked: {
                    ikkuna.particle_animation = 3
                    pageStack.pop(null, PageStackAction.Immediate)
                    pageStack.push(Qt.resolvedUrl("particle.qml"), null, PageStackAction.Immediate)
                }
            }
        }
        // Experimental "window" for showing the settings so that we can view the demo in background
        Rectangle {
            id: options_menu
            color: "#000000"
            width: 0
            height: 0
            visible: false
            //opacity: 0.8
            anchors.centerIn: parent
            Column {
                anchors.centerIn: parent
                spacing: Theme.paddingLarge
                Label {
                    text: "hello"
                    anchors {
                        left: parent.left
                        right: parent.right
                        margins: Theme.paddingLarge
                    }
                }
                Button {
                    text: "Close"
                    anchors.margins: 40
                    width: root.width/2
                    onClicked: {
                        options_menu.visible = false
                        options_menu.width = 0
                        options_menu.height = 0
                        rect.opacity = 1
                        mousearea.enabled = true
                    }
                }
            }
        }

        //Background covering whole screen
        Rectangle {
            id: rect
            width: root.width
            height: root.height
            color: "#999999"
            anchors.fill: parent
            ParticleSystem {
                id: particleSystem
            }
            // Mousearea for setting the clickable functions: adding friction, adding attraction point, etc..
            MouseArea {
                id: mousearea
                anchors.fill: rect
                onClicked: {
                    //console.log("Changing middle emitters location to: ", mouseX, mouseY)
                    /*middle_emitter.x = mouseX-(middle_emitter.width/2)
                    middle_emitter.y = mouseY-(middle_emitter.height/2)*/
                    if(ikkuna.click_action === 0) {
                        if(affector_att.strength > 0) {
                            affector_att.strength = 0
                            particle.color = "#330099"
                            particle.redVariation = 0
                            particle.blueVariation = 1
                            console.log("Removing attraction point")
                        }
                        else {
                            affector_att.pointX = mouseX
                            affector_att.pointY = mouseY
                            affector_att.strength = ikkuna.particle_str
                            particle.color = "#330000"
                            particle.redVariation = 1
                            particle.blueVariation = 0
                            console.log("Creating attraction point")
                        }
                    }
                    else if(ikkuna.click_action === 1) {
                        if(affector_fric.factor > 0) {
                            affector_fric.factor = 0
                            console.log("Removing friction")
                        }
                        else {
                            affector_fric.factor = ikkuna.particle_fric
                            console.log("Adding friction")
                        }
                    }


                }
                onPressAndHold: {
                    pageStack.push(Qt.resolvedUrl("particle_settings.qml"))
                    //Here is an alternative way to display settings: a rectangle in top of the running demo.
                    /*options_menu.visible = true
                    options_menu.x = root.width/4
                    options_menu.y = root.width/4
                    options_menu.width = (root.width*3)/4
                    options_menu.height = (root.height*3)/4
                    rect.opacity = 0.5
                    mousearea.enabled = false*/
                    //console.log("Showing menu")
                    //dialog.open(false, true)
                    //contextmenu.show(null)
                }
            }
            Emitter {
                //This emitter is in the middle
                id: middle_emitter
                system: particleSystem
                velocity: AngleDirection {
                    id: main_source
                }
                acceleration: AngleDirection {
                    id: main_acceleration
                }
            }
            Emitter {
                //This emitter covers whole area
                id: side_emitter
                system: particleSystem
                emitRate: 0

            }
            ImageParticle {
                id: particle
                system: particleSystem

            }
            //Affectors
            Turbulence {
                id: affector_tur
                system: particleSystem
                width: root.width
                height: root.height
                strength: 0
            }
            Attractor {
                id: affector_att
                system: particleSystem
                strength: 0
            }
            Friction {
                id: affector_fric
                system: particleSystem
                factor: 0
                threshold: 20
            }
            Gravity {
                id: affector_grav
                system: particleSystem
                magnitude: 0
            }
        }
    }
}
