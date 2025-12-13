import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    width: 30
    height: 30
    radius: 6

    // Properties
    property bool isBooked: false
    property bool isSelected: false
    property string seatNumber: ""

    // Color logic:
    // Gray (default/available) -> Teal/Green (when user clicks) -> Yellow (already booked from backend)
    color: {
        if (isBooked) return "#FFD700"  // Yellow - booked from backend
        if (isSelected) return "#20B2AA"  // Teal/Green - user selected
        return "#989898"  // Gray - available
    }

    border.color: {
        if (mouseArea.containsMouse) return "#00CED1"  // Cyan hover
        if (isBooked) return "#DAA520"  // Gold border for booked
        if (isSelected) return "#008B8B"  // Dark cyan for selected
        return "transparent"
    }
    border.width: (mouseArea.containsMouse || isBooked || isSelected) ? 2 : 0

    // Smooth color transition
    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    Behavior on border.width {
        NumberAnimation { duration: 150 }
    }

    // Click interaction
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: isBooked ? Qt.ForbiddenCursor : Qt.PointingHandCursor

        onClicked: {
            if (!isBooked) {
                root.isSelected = !root.isSelected
            }
        }
    }

    // Seat number label
    Text {
        anchors.centerIn: parent
        text: root.seatNumber
        color: {
            if (isBooked) return "#2F4F4F"
            if (isSelected) return "white"
            return "white"
        }
        font.pixelSize: 8
        font.bold: true
        visible: root.seatNumber !== ""
    }

    // Subtle scale effect on hover (only if not booked)
    scale: (mouseArea.containsMouse && !isBooked) ? 1.1 : 1.0
    Behavior on scale {
        NumberAnimation { duration: 150 }
    }
}
