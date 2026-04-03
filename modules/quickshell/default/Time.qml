pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    // an expression can be broken across multiple lines using {}
    readonly property string time: Qt.formatDateTime(clock.date, "ddd MMM d hh:mm:ss AP")

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
