import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Scope {
    // no more time object

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            // implicitHeight: 30

            // ClockWidget {
            // anchors.centerIn: parent
            // }
            ColumnLayout {
                id: a
                property int clicks: 0

                function incrementAndCall(callback) {
                    clicks += 1;
                    callback(clicks);
                }

                Button {
                    text: "click me"
                    onClicked: a.incrementAndCall(clicks => {
                        label.text = `the button was clicked ${clicks} time(s)!`;
                    })
                }

                Text {
                    id: label
                    text: "the button has not been clicked"
                }
            }
        }
    }
}
