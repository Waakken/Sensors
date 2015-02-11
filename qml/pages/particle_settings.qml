import QtQuick 2.0
import Sailfish.Silica 1.0

Page {

    id: page
    Column {
        anchors.centerIn: parent
        spacing: Theme.paddingLarge
        PageHeader {
            title: "Particle settings"
        }

        Column {
            visible: true
            Label {
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                text: "Attraction point strength: " + ikkuna.particle_str
            }
            Slider {
                id: str_slider
                maximumValue: 1
                minimumValue: 0
                stepSize: 0.1
                value: ikkuna.particle_str
                width: page.width
                onValueChanged: {
                    ikkuna.particle_str = str_slider.value
                }
            }
        }
        Column {
            visible: true
            Label {
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                text: "Friction factor: " + ikkuna.particle_fric
            }
            Slider {
                id: fric_slider
                maximumValue: 3
                minimumValue: 0
                stepSize: 0.1
                value: ikkuna.particle_fric
                width: page.width
                onValueChanged: {
                    ikkuna.particle_fric = fric_slider.value
                }
            }
        }
        Column {
            Label {
                text: "When clicking: "
                anchors {
                    margins: Theme.paddingLarge
                    horizontalCenter: parent.horizontalCenter
                }
            }

            ComboBox {
                width: page.width
                currentIndex: ikkuna.click_action
                anchors {
                    margins: Theme.paddingLarge
                    horizontalCenter: parent.horizontalCenter
                }
                menu: ContextMenu {
                    MenuItem {
                        text: "Add attraction point"
                        onClicked: { ikkuna.click_action = 0 }
                    }
                    MenuItem {
                        text: "Add friction"
                        onClicked: { ikkuna.click_action = 1 }
                    }
                }
            }
        }
        TextSwitch {
            id: storm_switch
            text: "Stormy conditions"
            checked: ikkuna.storm
            anchors {
                margins: Theme.paddingLarge
                horizontalCenter: parent.horizontalCenter
            }
            onClicked: {
                if (storm_switch.checked === false) {
                    ikkuna.storm = false
                    console.log("Disabling storm")
                }
                else {
                    ikkuna.storm = true
                    console.log("Enabling storm")
                }
            }
        }
        Slider {
            visible: true
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.paddingLarge
            }
            id: storm_slider
            maximumValue: 100
            minimumValue: 0
            stepSize: 1
            value: ikkuna.storm_str
            valueText: "Storm strength: " + storm_slider.value
            width: page.width
            onValueChanged: {
                ikkuna.storm_str = storm_slider.value
            }
        }
        Button {
            anchors {
                margins: Theme.paddingLarge
                horizontalCenter: parent.horizontalCenter
            }
            width: page.width/2
            text: "Close"
            onClicked: {
                pageStack.pop(null)
            }
        }
    }
}

