import QtQuick 2.0
import Sailfish.Silica 1.0
Page {
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        //anchors.margins: Theme.paddingLarge
        anchors.topMargin: Theme.paddingLarge
        //spacing: Theme.paddingLarge
        Label {
            text: "Load UI from HTTP server"
        }
        TextField {
            id: ip_text
            width: parent.width
            text: "82.130.9.186"
            color: Theme.highlightColor
        }

        Button {
            id: load_button
            text: "Load page"
            onClicked: {
                var url = 'http://' + ip_text.text + ':8080/main.qml'
                root.source = url
                console.log("Loading from: ", url)
            }
        }
        Button {
            id: open_button
            visible: false
            text: "Open UI"
            onClicked: {
                pageStack.push(new_item)
            }
        }
        Component {
            id: new_component
            Page {
                Label {
                    text: "hello"
                }
            }
        }
        Item {
            id: new_item
            Loader {
                id: root
                onLoaded: {
                    //root.width = item.width
                    //root.height = item.height
                    item.visible = false
                    open_button.visible = true
                    console.log("Loading complete")
                }
            }
        }

    }
}

