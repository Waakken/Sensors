import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: root
    Column {
        anchors {
            margins: Theme.paddingLarge
            horizontalCenter: parent.horizontalCenter
        }
        PageHeader {
            title: "Canvas settings:"
        }
        ComboBox {
            width: root.width
            currentIndex: ikkuna.canvas_mode
            menu: ContextMenu {
                MenuItem {
                    text: "Follow gravity"
                    onClicked: { ikkuna.canvas_mode = 0 }
                }
                MenuItem {
                    text: "Follow magnetic field"
                    onClicked: { ikkuna.canvas_mode = 1 }
                }
            }
        }
        TextSwitch {
            id: clear_switch
            text: "Clear before drawing new"
            checked: ikkuna.canvas_clear

            onClicked: {
                if (clear_switch.checked === false) {
                    ikkuna.canvas_clear = false
                    //console.log("Disabling storm")
                }
                else {
                    ikkuna.canvas_clear = true
                    //console.log("Enabling storm")
                }
            }
        }
    }
}

