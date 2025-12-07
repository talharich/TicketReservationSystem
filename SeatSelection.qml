import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    anchors.fill: parent
    color: "#0f1419"

    property string flightNumber: "F102"
    property string route: "London → Paris"
    property string passengerName: ""
    property int selectedSeat: -1

    // Seat layout: 6 seats per row (A-F), 10 rows
    property var seatStatus: [
        1, 1, 0, 0, 0, 0,  // Row 1
        1, 0, 0, 1, 0, 0,  // Row 2
        0, 0, 1, 0, 0, 0,  // Row 3
        0, 0, 0, 0, 1, 1,  // Row 4
        0, 0, 0, 0, 0, 0,  // Row 5
        1, 0, 0, 0, 0, 1,  // Row 6
        0, 1, 0, 0, 0, 0,  // Row 7
        0, 0, 0, 1, 0, 0,  // Row 8
        0, 0, 0, 0, 0, 0,  // Row 9
        0, 0, 0, 0, 0, 0   // Row 10
    ] // 0 = available, 1 = booked

    ScrollView {
        anchors.fill: parent
        anchors.margins: 30
        clip: true

        Column {
            width: parent.width - 60
            spacing: 30

            // Header
            Row {
                width: parent.width
                spacing: 20

                Column {
                    spacing: 5
                    Text {
                        text: "Select Your Seat"
                        color: "white"
                        font.pixelSize: 32
                        font.bold: true
                    }
                    Text {
                        text: "Flight " + flightNumber + " • " + route
                        color: "#7d8590"
                        font.pixelSize: 18
                    }
                }
            }

            // Legend
            Rectangle {
                width: 600
                height: 100
                color: "#161b22"
                radius: 12
                border.color: "#30363d"
                border.width: 1

                Row {
                    anchors.centerIn: parent
                    spacing: 50

                    Row {
                        spacing: 10
                        Rectangle {
                            width: 40
                            height: 40
                            color: "#0f1419"
                            radius: 6
                            border.color: "#3fb950"
                            border.width: 2
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "Available"
                            color: "white"
                            font.pixelSize: 16
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        spacing: 10
                        Rectangle {
                            width: 40
                            height: 40
                            color: "#58a6ff"
                            radius: 6
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "Selected"
                            color: "white"
                            font.pixelSize: 16
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        spacing: 10
                        Rectangle {
                            width: 40
                            height: 40
                            color: "#6e7681"
                            radius: 6
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "Booked"
                            color: "white"
                            font.pixelSize: 16
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }

            // Airplane visualization
            Rectangle {
                width: 700
                height: 900
                color: "#161b22"
                radius: 20
                border.color: "#30363d"
                border.width: 1
                anchors.horizontalCenter: parent.horizontalCenter

                Column {
                    anchors.fill: parent
                    anchors.margins: 40
                    spacing: 20

                    // Cockpit indicator
                    Text {
                        text: "✈ FRONT"
                        color: "#7d8590"
                        font.pixelSize: 14
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Rectangle {
                        width: parent.width
                        height: 2
                        color: "#30363d"
                    }

                    // Seat labels (A-F)
                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 20

                        Repeater {
                            model: ["A", "B", "C", "", "D", "E", "F"]
                            Text {
                                text: modelData
                                color: "#7d8590"
                                font.pixelSize: 14
                                font.bold: true
                                width: 60
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }

                    // Seats grid
                    Column {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 15

                        Repeater {
                            model: 10 // 10 rows

                            Row {
                                spacing: 20

                                property int rowNum: index

                                // Row number
                                Text {
                                    text: (rowNum + 1).toString()
                                    color: "#7d8590"
                                    font.pixelSize: 16
                                    font.bold: true
                                    width: 30
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                // Seats A, B, C
                                Repeater {
                                    model: 3
                                    Rectangle {
                                        width: 60
                                        height: 60
                                        radius: 8

                                        property int seatIndex: rowNum * 6 + index
                                        property bool isBooked: seatStatus[seatIndex] === 1
                                        property bool isSelected: selectedSeat === seatIndex

                                        color: isSelected ? "#58a6ff" : (isBooked ? "#6e7681" : "#0f1419")
                                        border.color: isSelected ? "#58a6ff" : (isBooked ? "#6e7681" : "#3fb950")
                                        border.width: 2

                                        Text {
                                            anchors.centerIn: parent
                                            text: String.fromCharCode(65 + index) // A, B, C
                                            color: parent.isBooked ? "#484f58" : "white"
                                            font.pixelSize: 18
                                            font.bold: true
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            enabled: !parent.isBooked
                                            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
                                            onClicked: {
                                                selectedSeat = parent.seatIndex
                                            }
                                        }
                                    }
                                }

                                // Aisle
                                Item { width: 40; height: 60 }

                                // Seats D, E, F
                                Repeater {
                                    model: 3
                                    Rectangle {
                                        width: 60
                                        height: 60
                                        radius: 8

                                        property int seatIndex: rowNum * 6 + 3 + index
                                        property bool isBooked: seatStatus[seatIndex] === 1
                                        property bool isSelected: selectedSeat === seatIndex

                                        color: isSelected ? "#58a6ff" : (isBooked ? "#6e7681" : "#0f1419")
                                        border.color: isSelected ? "#58a6ff" : (isBooked ? "#6e7681" : "#3fb950")
                                        border.width: 2

                                        Text {
                                            anchors.centerIn: parent
                                            text: String.fromCharCode(68 + index) // D, E, F
                                            color: parent.isBooked ? "#484f58" : "white"
                                            font.pixelSize: 18
                                            font.bold: true
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            enabled: !parent.isBooked
                                            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
                                            onClicked: {
                                                selectedSeat = parent.seatIndex
                                            }
                                        }
                                    }
                                }

                                // Row number (right side)
                                Text {
                                    text: (rowNum + 1).toString()
                                    color: "#7d8590"
                                    font.pixelSize: 16
                                    font.bold: true
                                    width: 30
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }
                    }

                    Item { height: 10 }

                    Rectangle {
                        width: parent.width
                        height: 2
                        color: "#30363d"
                    }

                    Text {
                        text: "BACK"
                        color: "#7d8590"
                        font.pixelSize: 14
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            // Booking confirmation section
            Rectangle {
                width: 700
                height: 200
                color: "#161b22"
                radius: 12
                border.color: "#30363d"
                border.width: 1
                anchors.horizontalCenter: parent.horizontalCenter
                visible: selectedSeat >= 0

                Column {
                    anchors.centerIn: parent
                    spacing: 20
                    width: parent.width - 60

                    Text {
                        text: "Selected Seat: " + (selectedSeat >= 0 ? (Math.floor(selectedSeat / 6) + 1) + String.fromCharCode(65 + (selectedSeat % 6)) : "None")
                        color: "white"
                        font.pixelSize: 24
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    TextField {
                        id: nameInput
                        width: 400
                        height: 50
                        placeholderText: "Enter passenger name"
                        font.pixelSize: 16
                        anchors.horizontalCenter: parent.horizontalCenter
                        background: Rectangle {
                            color: "#0f1419"
                            radius: 8
                            border.color: "#30363d"
                            border.width: 1
                        }
                        color: "white"
                    }

                    Button {
                        text: "Confirm Booking"
                        width: 300
                        height: 50
                        anchors.horizontalCenter: parent.horizontalCenter
                        enabled: nameInput.text.length > 0

                        background: Rectangle {
                            color: parent.enabled ? (parent.hovered ? "#1f6feb" : "#0969da") : "#30363d"
                            radius: 8
                        }

                        contentItem: Text {
                            text: parent.text
                            color: parent.enabled ? "white" : "#6e7681"
                            font.pixelSize: 16
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            console.log("Booking confirmed!")
                            console.log("Seat:", Math.floor(selectedSeat / 6) + 1 + String.fromCharCode(65 + (selectedSeat % 6)))
                            console.log("Name:", nameInput.text)
                            // Call backend booking function here
                        }
                    }
                }
            }
        }
    }
}
