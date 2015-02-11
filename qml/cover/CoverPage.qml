import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Grid {
        columns: 2
        x: Theme.paddingLarge
        y: Theme.paddingLarge
        spacing: Theme.paddingLarge
        Label {
            text: "X: "
        }
        Label {
            text: ikkuna.x_avg
        }
        Label {
            text: "Y: "
        }
        Label {
            text: ikkuna.y_avg
        }
        Label {
            text: "Z: "
        }
        Label {
            text: ikkuna.z_avg
        }
        Label {
            text: "Abs: "
        }
        Label {
            text: ikkuna.abs_avg
        }

    }

}

