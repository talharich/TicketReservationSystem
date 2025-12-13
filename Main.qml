import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    width: 1920
    height: 1080
    visible: true
    visibility: window.Maximized
    title: "Airline Reservation System"

    property bool isLoggedIn: false
    property string currentView: "flights" // flights, bookings, search, seatSelection
    property var flightsList: []
    property var searchResults: []
    property var selectedFlight: null

    Rectangle {
        anchors.fill: parent
        color: "#0f1419"

        // Login Screen
        Rectangle {
            id: loginScreen
            anchors.fill: parent
            visible: !isLoggedIn
            color: "#0f1419"

            Rectangle {
                anchors.centerIn: parent
                width: 600
                height: 500
                color: "#1c2128"
                radius: 12

                Column {
                    anchors.centerIn: parent
                    spacing: 30

                    Text {
                        text: "✈ Airline Login"
                        color: "white"
                        font.pixelSize: 32
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    TextField {
                        id: usernameField
                        width: 400
                        placeholderText: "Username"
                        font.pixelSize: 18
                        background: Rectangle {
                            color: "#0f1419"
                            radius: 6
                        }
                        color: "white"
                    }

                    TextField {
                        id: passwordField
                        width: 400
                        placeholderText: "Password"
                        echoMode: TextInput.Password
                        font.pixelSize: 18
                        background: Rectangle {
                            color: "#0f1419"
                            radius: 6
                        }
                        color: "white"
                    }

                    Button {
                        text: "Login"
                        width: 200
                        height: 45
                        anchors.horizontalCenter: parent.horizontalCenter

                        background: Rectangle {
                            color: parent.hovered ? "#2ea44f" : "#238636"
                            radius: 6
                        }

                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            font.pixelSize: 16
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            var result = loginHandler.attemptLogin(usernameField.text, passwordField.text)
                            statusText.text = result

                            if (result.indexOf("✓") !== -1) {
                                statusText.color = "#3fb950"
                                isLoggedIn = true
                                flightsList = flightHandler.getAllFlights()
                            } else {
                                statusText.color = "#f85149"
                            }
                        }
                    }

                    Text {
                        id: statusText
                        text: ""
                        color: "white"
                        font.pixelSize: 16
                        width: 400
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        text: "Demo: admin / admin123"
                        color: "#7d8590"
                        font.pixelSize: 14
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }

        // Main Application (after login)
        Rectangle {
            id: mainApp
            anchors.fill: parent
            visible: isLoggedIn
            color: "#0f1419"

            // Sidebar Navigation
            Rectangle {
                id: sidebar
                width: 225
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                color: "#161b22"
                border.color: "#30363d"
                border.width: 1

                Column {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 10

                    // Logo/Title
                    Text {
                        text: "✈ Airline System"
                        color: "white"
                        font.pixelSize: 22
                        font.bold: true
                        width: parent.width
                    }

                    Rectangle {
                        width: parent.width
                        height: 2
                        color: "#30363d"
                    }

                    // Navigation Buttons
                    Button {
                        width: parent.width
                        height: 45

                        background: Rectangle {
                            color: currentView === "flights" ? "#238636" : (parent.hovered ? "#1c2128" : "transparent")
                            radius: 6
                        }

                        contentItem: Row {
                            spacing: 12
                            leftPadding: 10

                            Text {
                                text: "✈"
                                color: "white"
                                font.pixelSize: 18
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: "All Flights"
                                color: "white"
                                font.pixelSize: 15
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        onClicked: currentView = "flights"
                    }

                    Button {
                        width: parent.width
                        height: 45

                        background: Rectangle {
                            color: currentView === "search" ? "#238636" : (parent.hovered ? "#1c2128" : "transparent")
                            radius: 6
                        }

                        contentItem: Row {
                            spacing: 12
                            leftPadding: 10

                            Text {
                                text: "🔍"
                                color: "white"
                                font.pixelSize: 18
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: "Search Flights"
                                color: "white"
                                font.pixelSize: 15
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        onClicked: currentView = "search"
                    }

                    Button {
                        width: parent.width
                        height: 45

                        background: Rectangle {
                            color: currentView === "bookings" ? "#238636" : (parent.hovered ? "#1c2128" : "transparent")
                            radius: 6
                        }

                        contentItem: Row {
                            spacing: 12
                            leftPadding: 10

                            Text {
                                text: "📋"
                                color: "white"
                                font.pixelSize: 18
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: "My Bookings"
                                color: "white"
                                font.pixelSize: 15
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        onClicked: currentView = "bookings"
                    }

                    Item {
                        width: parent.width
                        height: parent.height - 400
                    }

                    // Logout Button
                    Rectangle {
                        y: 880
                        width: parent.width
                        height: 2
                        color: "#30363d"
                    }

                    Button {
                        width: 180
                        text: "Logout"
                        height: 45

                        background: Rectangle {
                            color: parent.hovered ? "#da3633" : "#0f1419"
                            radius: 6
                            border.color: "#f85149"
                            border.width: 1
                        }

                        contentItem: Text {
                            width: 170
                            text: parent.text
                            color: "#f85149"
                            font.pixelSize: 14
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            isLoggedIn = false
                            usernameField.text = ""
                            passwordField.text = ""
                            statusText.text = ""
                        }
                    }
                }
            }

            // Main Content Area
            Rectangle {
                anchors.left: sidebar.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                color: "#0f1419"

                // All Flights View
                ScrollView {
                    anchors.fill: parent
                    anchors.margins: 30
                    visible: currentView === "flights"
                    clip: true

                    Column {
                        width: parent.width - 60
                        spacing: 20

                        Text {
                            text: "Available Flights"
                            color: "white"
                            font.pixelSize: 32
                            font.bold: true
                        }

                        Repeater {
                            model: flightsList
                            delegate: Rectangle {
                                width: 1100
                                height: 120
                                color: "#161b22"
                                radius: 12
                                border.color: flightMouse.containsMouse ? "#58a6ff" : "#30363d"
                                border.width: 1

                                property var flightData: modelData

                                MouseArea {
                                    id: flightMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                }

                                Row {
                                    anchors.fill: parent
                                    anchors.margins: 25
                                    spacing: 30

                                    Column {
                                        spacing: 8
                                        width: 100
                                        Text { text: "Flight"; color: "#7d8590"; font.pixelSize: 12 }
                                        Text { text: flightData.flightNumber; color: "#58a6ff"; font.pixelSize: 24; font.bold: true }
                                    }

                                    Rectangle { width: 1; height: parent.height; color: "#30363d" }

                                    Column {
                                        spacing: 8
                                        width: 300
                                        Text { text: "Route"; color: "#7d8590"; font.pixelSize: 12 }
                                        Row {
                                            spacing: 15
                                            Text { text: flightData.origin; color: "white"; font.pixelSize: 18; font.bold: true }
                                            Text { text: "→"; color: "#7d8590"; font.pixelSize: 18 }
                                            Text { text: flightData.destination; color: "white"; font.pixelSize: 18; font.bold: true }
                                        }
                                    }

                                    Rectangle { width: 1; height: parent.height; color: "#30363d" }

                                    Column {
                                        spacing: 8
                                        width: 100
                                        Text { text: "Departure"; color: "#7d8590"; font.pixelSize: 12 }
                                        Text { text: flightData.time; color: "white"; font.pixelSize: 18 }
                                    }

                                    Rectangle { width: 1; height: parent.height; color: "#30363d" }

                                    Column {
                                        spacing: 8
                                        width: 120
                                        Text { text: "Available"; color: "#7d8590"; font.pixelSize: 12 }
                                        Text {
                                            text: flightData.availableSeats + "/" + flightData.totalSeats
                                            color: "#3fb950"
                                            font.pixelSize: 18
                                            font.bold: true
                                        }
                                    }

                                    Item { width: 50; height: 1 }

                                    Button {
                                        text: "Book"
                                        width: 100
                                        height: 45
                                        anchors.verticalCenter: parent.verticalCenter
                                        background: Rectangle {
                                            color: parent.hovered ? "#238636" : "#0f1419"
                                            radius: 6
                                            border.color: "#3fb950"
                                            border.width: 1
                                        }
                                        contentItem: Text {
                                            text: parent.text
                                            color: "#3fb950"
                                            font.pixelSize: 14
                                            font.bold: true
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                        onClicked: {
                                            selectedFlight = flightData
                                            currentView = "seatSelection"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // Search Flights View
                ScrollView {
                    anchors.fill: parent
                    anchors.margins: 30
                    visible: currentView === "search"
                    clip: true

                    Column {
                        width: parent.width - 60
                        spacing: 30

                        Text {
                            text: "Search Flights"
                            color: "white"
                            font.pixelSize: 32
                            font.bold: true
                        }

                        // Search Form - Fixed Horizontal Layout
                        Rectangle {
                            width: 900
                            height: 150
                            color: "#161b22"
                            radius: 12
                            border.color: "#30363d"
                            border.width: 1

                            Row {
                                anchors.centerIn: parent
                                spacing: 20

                                Column {
                                    spacing: 8
                                    width: 280

                                    Text {
                                        text: "From"
                                        color: "#7d8590"
                                        font.pixelSize: 14
                                    }

                                    TextField {
                                        id: searchFrom
                                        width: 280
                                        height: 40
                                        placeholderText: "Origin city"
                                        font.pixelSize: 16
                                        background: Rectangle {
                                            color: "#0f1419"
                                            radius: 6
                                            border.color: "#30363d"
                                            border.width: 1
                                        }
                                        color: "white"
                                    }
                                }

                                Column {
                                    spacing: 8
                                    width: 280

                                    Text {
                                        text: "To"
                                        color: "#7d8590"
                                        font.pixelSize: 14
                                    }

                                    TextField {
                                        id: searchTo
                                        width: 280
                                        height: 40
                                        placeholderText: "Destination city"
                                        font.pixelSize: 16
                                        background: Rectangle {
                                            color: "#0f1419"
                                            radius: 6
                                            border.color: "#30363d"
                                            border.width: 1
                                        }
                                        color: "white"
                                    }
                                }

                                Column {
                                    spacing: 8
                                    width: 180

                                    Text {
                                        text: " "
                                        color: "transparent"
                                        font.pixelSize: 14
                                    }

                                    Button {
                                        text: "Search"
                                        width: 180
                                        height: 45

                                        background: Rectangle {
                                            color: parent.hovered ? "#1f6feb" : "#0969da"
                                            radius: 6
                                        }

                                        contentItem: Text {
                                            text: parent.text
                                            color: "white"
                                            font.pixelSize: 16
                                            font.bold: true
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        onClicked: {
                                            console.log("Searching from:", searchFrom.text, "to:", searchTo.text)
                                            var results = flightHandler.searchFlights(searchFrom.text, searchTo.text)
                                            searchResults = results
                                            console.log("Search results:", results)
                                            console.log("Results length:", results ? results.length : "null/undefined")
                                        }
                                    }
                                }
                            }
                        }

                        // Results Header - Shows AFTER search
                        Text {
                            id: resultsHeader
                            width: parent.width
                            anchors.horizontalCenter: parent.horizontalCenter
                            visible: searchResults !== undefined && searchResults !== null && searchResults.length > 0
                            text: {
                                if (!searchResults) {
                                    return ""
                                }
                                if (searchResults.length > 0) {
                                    return "✓ Found " + searchResults.length + " flight(s)"
                                } else {
                                    return ""
                                }
                            }
                            color: "#3fb950"
                            font.pixelSize: 20
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                        }

                        // Search Results List
                        Repeater {
                            model: searchResults
                            delegate: Rectangle {
                                width: parent.width
                                height: 150
                                color: "#161b22"
                                radius: 12
                                border.color: searchFlightMouse.containsMouse ? "#58a6ff" : "#30363d"
                                border.width: 1

                                property var flightData: modelData

                                MouseArea {
                                    id: searchFlightMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                }

                                Row {
                                    anchors.fill: parent
                                    anchors.margins: 25
                                    spacing: 20

                                    Column {
                                        spacing: 8
                                        width: 90
                                        anchors.verticalCenter: parent.verticalCenter
                                        Text {
                                            text: "Flight"
                                            color: "#7d8590"
                                            font.pixelSize: 12
                                        }
                                        Text {
                                            text: flightData.flightNumber
                                            color: "#58a6ff"
                                            font.pixelSize: 24
                                            font.bold: true
                                        }
                                    }

                                    Rectangle {
                                        width: 1
                                        height: parent.height - 20
                                        color: "#30363d"
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Column {
                                        spacing: 8
                                        width: 220
                                        anchors.verticalCenter: parent.verticalCenter
                                        Text {
                                            text: "Route"
                                            color: "#7d8590"
                                            font.pixelSize: 12
                                        }
                                        Row {
                                            spacing: 15
                                            Text {
                                                text: flightData.origin
                                                color: "white"
                                                font.pixelSize: 18
                                                font.bold: true
                                            }
                                            Text {
                                                text: "→"
                                                color: "#7d8590"
                                                font.pixelSize: 18
                                            }
                                            Text {
                                                text: flightData.destination
                                                color: "white"
                                                font.pixelSize: 18
                                                font.bold: true
                                            }
                                        }
                                    }

                                    Rectangle {
                                        width: 1
                                        height: parent.height - 20
                                        color: "#30363d"
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Column {
                                        spacing: 8
                                        width: 90
                                        anchors.verticalCenter: parent.verticalCenter
                                        Text {
                                            text: "Departure"
                                            color: "#7d8590"
                                            font.pixelSize: 12
                                        }
                                        Text {
                                            text: flightData.time
                                            color: "white"
                                            font.pixelSize: 18
                                        }
                                    }

                                    Rectangle {
                                        width: 1
                                        height: parent.height - 20
                                        color: "#30363d"
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Column {
                                        spacing: 8
                                        width: 90
                                        anchors.verticalCenter: parent.verticalCenter
                                        Text {
                                            text: "Available"
                                            color: "#7d8590"
                                            font.pixelSize: 12
                                        }
                                        Text {
                                            text: flightData.availableSeats + "/" + flightData.totalSeats
                                            color: "#3fb950"
                                            font.pixelSize: 18
                                            font.bold: true
                                        }
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                        height: 1
                                    }

                                    Button {
                                        text: "Book"
                                        width: 90
                                        height: 45
                                        anchors.verticalCenter: parent.verticalCenter

                                        background: Rectangle {
                                            color: parent.hovered ? "#238636" : "#0f1419"
                                            radius: 6
                                            border.color: "#3fb950"
                                            border.width: 1
                                        }

                                        contentItem: Text {
                                            text: parent.text
                                            color: "#3fb950"
                                            font.pixelSize: 14
                                            font.bold: true
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        onClicked: {
                                            selectedFlight = flightData
                                            currentView = "seatSelection"
                                        }
                                    }
                                }
                            }
                        }

                        // Empty state - Shows when search returns no results
                        Rectangle {
                            width: 200
                            height: 200
                            color: "transparent"
                            transformOrigin: Item.Center
                            visible: {
                                var hasSearched = searchResults !== undefined && searchResults !== null
                                var noResults = searchResults !== undefined &&
                                               searchResults !== null &&
                                               searchResults.length === 0
                                console.log("Empty state - hasSearched:", hasSearched, "noResults:", noResults)
                                return hasSearched && noResults
                            }

                            Column {
                                anchors.verticalCenterOffset: 205
                                anchors.horizontalCenterOffset: 669
                                anchors.centerIn: parent
                                spacing: 20

                                Text {
                                    text: "✈"
                                    color: "#30363d"
                                    font.pixelSize: 80
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "No flights found"
                                    color: "#7d8590"
                                    font.pixelSize: 24
                                    font.bold: true
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "Try searching with different cities"
                                    color: "#484f58"
                                    font.pixelSize: 16
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                }

                // My Bookings View
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 30
                    visible: currentView === "bookings"
                    color: "transparent"

                    Column {
                        width: parent.width
                        spacing: 20

                        Text {
                            text: "My Bookings"
                            color: "white"
                            font.pixelSize: 32
                            font.bold: true
                        }

                        Text {
                            text: "No bookings yet"
                            color: "#7d8590"
                            font.pixelSize: 18
                        }
                    }
                }

                // Seat Selection View
                                Rectangle {
                                    id: seatSelectionView
                                    anchors.fill: parent
                                    anchors.margins: 30
                                    visible: currentView === "seatSelection"
                                    color: "transparent"

                                    property var bookedSeats: []
                                    property string selectedSeatId: ""

                                    // Load booked seats when view becomes visible
                                    onVisibleChanged: {
                                        if (visible && selectedFlight) {
                                            bookedSeats = flightHandler.getBookedSeats(selectedFlight.flightNumber)
                                            selectedSeatId = ""
                                        }
                                    }

                                    function isSeatBooked(seatId) {
                                        return bookedSeats.indexOf(seatId) !== -1
                                    }

                                    ScrollView {
                                        anchors.fill: parent
                                        clip: true
                                        contentWidth: seatColumn.width
                                        contentHeight: seatColumn.height

                                        Column {
                                            id: seatColumn
                                            width: 1200
                                            spacing: 20

                                            // Back button
                                            Button {
                                                text: "← Back to Flights"
                                                width: 180
                                                height: 45

                                                background: Rectangle {
                                                    color: parent.hovered ? "#1c2128" : "transparent"
                                                    radius: 6
                                                    border.color: "#30363d"
                                                    border.width: 1
                                                }

                                                contentItem: Text {
                                                    text: parent.text
                                                    color: "#58a6ff"
                                                    font.pixelSize: 14
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                }

                                                onClicked: {
                                                    currentView = "flights"
                                                    seatSelectionView.selectedSeatId = ""
                                                }
                                            }

                                            // Header
                                            Column {
                                                spacing: 5
                                                Text {
                                                    text: "Select Your Seat"
                                                    color: "white"
                                                    font.pixelSize: 32
                                                    font.bold: true
                                                }
                                                Text {
                                                    text: selectedFlight ? "Flight " + selectedFlight.flightNumber + " • " + selectedFlight.origin + " → " + selectedFlight.destination : ""
                                                    color: "#7d8590"
                                                    font.pixelSize: 18
                                                }
                                            }

                                            // Legend
                                            Rectangle {
                                                width: 700
                                                height: 80
                                                color: "#161b22"
                                                radius: 12
                                                border.color: "#30363d"
                                                border.width: 1

                                                Row {
                                                    anchors.centerIn: parent
                                                    spacing: 40

                                                    Row {
                                                        spacing: 10
                                                        Rectangle {
                                                            width: 35
                                                            height: 35
                                                            color: "#989898"
                                                            radius: 6
                                                            anchors.verticalCenter: parent.verticalCenter
                                                        }
                                                        Text {
                                                            text: "Available"
                                                            color: "white"
                                                            font.pixelSize: 14
                                                            anchors.verticalCenter: parent.verticalCenter
                                                        }
                                                    }

                                                    Row {
                                                        spacing: 10
                                                        Rectangle {
                                                            width: 35
                                                            height: 35
                                                            color: "#20B2AA"
                                                            radius: 6
                                                            anchors.verticalCenter: parent.verticalCenter
                                                        }
                                                        Text {
                                                            text: "Selected"
                                                            color: "white"
                                                            font.pixelSize: 14
                                                            anchors.verticalCenter: parent.verticalCenter
                                                        }
                                                    }

                                                    Row {
                                                        spacing: 10
                                                        Rectangle {
                                                            width: 35
                                                            height: 35
                                                            color: "#FFD700"
                                                            radius: 6
                                                            anchors.verticalCenter: parent.verticalCenter
                                                        }
                                                        Text {
                                                            text: "Booked"
                                                            color: "white"
                                                            font.pixelSize: 14
                                                            anchors.verticalCenter: parent.verticalCenter
                                                        }
                                                    }
                                                }
                                            }

                                            // Airplane seating chart - SCALED DOWN
                                            Rectangle {
                                                width: 1200
                                                height: 675
                                                color: "#ffffff"
                                                radius: 12
                                                border.color: "#30363d"
                                                border.width: 1
                                                clip: true

                                                // Container for the scaled content
                                                Item {
                                                    anchors.fill: parent
                                                    scale: 0.625  // Scale factor: 1200/1920 = 0.625
                                                    transformOrigin: Item.TopLeft

                                                    Image {
                                                        id: airplaneImage
                                                        x: 160
                                                        y: 90
                                                        width: 1600
                                                        height: 900
                                                        source: "file:///D:/TicketReservationSystem/images/Airplane seating chart.png"
                                                        fillMode: Image.PreserveAspectFit

                                                        // Right section - Column 1 (A seats)
                                                        SeatButton {
                                                            id: seat1A
                                                            x: 1081
                                                            y: 327
                                                            seatNumber: "1A"
                                                        }

                                                        SeatButton {
                                                            id: seat2A
                                                            x: 1081
                                                            y: 366
                                                            seatNumber: "2A"
                                                        }

                                                        SeatButton {
                                                            id: seat3A
                                                            x: 1081
                                                            y: 404
                                                            seatNumber: "3A"
                                                        }

                                                        SeatButton {
                                                            id: seat4A
                                                            x: 1081
                                                            y: 477
                                                            seatNumber: "4A"
                                                        }

                                                        SeatButton {
                                                            id: seat5A
                                                            x: 1081
                                                            y: 516
                                                            seatNumber: "5A"
                                                        }

                                                        SeatButton {
                                                            id: seat6A
                                                            x: 1081
                                                            y: 554
                                                            seatNumber: "6A"
                                                        }

                                                        // Right section - Column 2 (B seats)
                                                        SeatButton {
                                                            id: seat1B
                                                            x: 1042
                                                            y: 327
                                                            seatNumber: "1B"
                                                        }

                                                        SeatButton {
                                                            id: seat2B
                                                            x: 1042
                                                            y: 366
                                                            seatNumber: "2B"
                                                        }

                                                        SeatButton {
                                                            id: seat3B
                                                            x: 1042
                                                            y: 404
                                                            seatNumber: "3B"
                                                        }

                                                        SeatButton {
                                                            id: seat4B
                                                            x: 1042
                                                            y: 477
                                                            seatNumber: "4B"
                                                        }

                                                        SeatButton {
                                                            id: seat5B
                                                            x: 1042
                                                            y: 516
                                                            seatNumber: "5B"
                                                        }

                                                        SeatButton {
                                                            id: seat6B
                                                            x: 1042
                                                            y: 554
                                                            seatNumber: "6B"
                                                        }

                                                        // Right section - Column 3 (C seats)
                                                        SeatButton {
                                                            id: seat1C
                                                            x: 1003
                                                            y: 327
                                                            seatNumber: "1C"
                                                        }

                                                        SeatButton {
                                                            id: seat2C
                                                            x: 1003
                                                            y: 366
                                                            seatNumber: "2C"
                                                        }

                                                        SeatButton {
                                                            id: seat3C
                                                            x: 1003
                                                            y: 404
                                                            seatNumber: "3C"
                                                        }

                                                        SeatButton {
                                                            id: seat4C
                                                            x: 1003
                                                            y: 477
                                                            seatNumber: "4C"
                                                        }

                                                        SeatButton {
                                                            id: seat5C
                                                            x: 1003
                                                            y: 516
                                                            seatNumber: "5C"
                                                        }

                                                        SeatButton {
                                                            id: seat6C
                                                            x: 1003
                                                            y: 554
                                                            seatNumber: "6C"
                                                        }

                                                        // Right-middle section - Column 1 (D seats)
                                                        SeatButton {
                                                            id: seat1D
                                                            x: 967
                                                            y: 327
                                                            seatNumber: "1D"
                                                        }

                                                        SeatButton {
                                                            id: seat2D
                                                            x: 967
                                                            y: 366
                                                            seatNumber: "2D"
                                                        }

                                                        SeatButton {
                                                            id: seat3D
                                                            x: 967
                                                            y: 404
                                                            seatNumber: "3D"
                                                        }

                                                        SeatButton {
                                                            id: seat4D
                                                            x: 967
                                                            y: 477
                                                            seatNumber: "4D"
                                                        }

                                                        SeatButton {
                                                            id: seat5D
                                                            x: 967
                                                            y: 516
                                                            seatNumber: "5D"
                                                        }

                                                        SeatButton {
                                                            id: seat6D
                                                            x: 967
                                                            y: 554
                                                            seatNumber: "6D"
                                                        }

                                                        // Right-middle section - Column 2 (E seats)
                                                        SeatButton {
                                                            id: seat1E
                                                            x: 928
                                                            y: 327
                                                            seatNumber: "1E"
                                                        }

                                                        SeatButton {
                                                            id: seat2E
                                                            x: 928
                                                            y: 366
                                                            seatNumber: "2E"
                                                        }

                                                        SeatButton {
                                                            id: seat3E
                                                            x: 928
                                                            y: 404
                                                            seatNumber: "3E"
                                                        }

                                                        SeatButton {
                                                            id: seat4E
                                                            x: 928
                                                            y: 477
                                                            seatNumber: "4E"
                                                        }

                                                        SeatButton {
                                                            id: seat5E
                                                            x: 928
                                                            y: 516
                                                            seatNumber: "5E"
                                                        }

                                                        SeatButton {
                                                            id: seat6E
                                                            x: 928
                                                            y: 554
                                                            seatNumber: "6E"
                                                        }

                                                        // Right-middle section - Column 3 (F seats)
                                                        SeatButton {
                                                            id: seat1F
                                                            x: 889
                                                            y: 327
                                                            seatNumber: "1F"
                                                        }

                                                        SeatButton {
                                                            id: seat2F
                                                            x: 889
                                                            y: 366
                                                            seatNumber: "2F"
                                                        }

                                                        SeatButton {
                                                            id: seat3F
                                                            x: 889
                                                            y: 404
                                                            seatNumber: "3F"
                                                        }

                                                        SeatButton {
                                                            id: seat4F
                                                            x: 889
                                                            y: 477
                                                            seatNumber: "4F"
                                                        }

                                                        SeatButton {
                                                            id: seat5F
                                                            x: 889
                                                            y: 516
                                                            seatNumber: "5F"
                                                        }

                                                        SeatButton {
                                                            id: seat6F
                                                            x: 889
                                                            y: 554
                                                            seatNumber: "6F"
                                                        }

                                                        // Center-right section - Column 1 (G seats)
                                                        SeatButton {
                                                            id: seat1G
                                                            x: 851
                                                            y: 327
                                                            seatNumber: "1G"
                                                        }

                                                        SeatButton {
                                                            id: seat2G
                                                            x: 851
                                                            y: 366
                                                            seatNumber: "2G"
                                                        }

                                                        SeatButton {
                                                            id: seat3G
                                                            x: 851
                                                            y: 404
                                                            seatNumber: "3G"
                                                        }

                                                        SeatButton {
                                                            id: seat4G
                                                            x: 851
                                                            y: 477
                                                            seatNumber: "4G"
                                                        }

                                                        SeatButton {
                                                            id: seat5G
                                                            x: 851
                                                            y: 516
                                                            seatNumber: "5G"
                                                        }

                                                        SeatButton {
                                                            id: seat6G
                                                            x: 851
                                                            y: 554
                                                            seatNumber: "6G"
                                                        }

                                                        // Center-right section - Column 2 (H seats)
                                                        SeatButton {
                                                            id: seat1H
                                                            x: 812
                                                            y: 327
                                                            seatNumber: "1H"
                                                        }

                                                        SeatButton {
                                                            id: seat2H
                                                            x: 812
                                                            y: 366
                                                            seatNumber: "2H"
                                                        }

                                                        SeatButton {
                                                            id: seat3H
                                                            x: 812
                                                            y: 404
                                                            seatNumber: "3H"
                                                        }

                                                        SeatButton {
                                                            id: seat4H
                                                            x: 812
                                                            y: 477
                                                            seatNumber: "4H"
                                                        }

                                                        SeatButton {
                                                            id: seat5H
                                                            x: 812
                                                            y: 516
                                                            seatNumber: "5H"
                                                        }

                                                        SeatButton {
                                                            id: seat6H
                                                            x: 812
                                                            y: 554
                                                            seatNumber: "6H"
                                                        }

                                                        // Center-right section - Column 3 (I seats)
                                                        SeatButton {
                                                            id: seat1I
                                                            x: 773
                                                            y: 327
                                                            seatNumber: "1I"
                                                        }

                                                        SeatButton {
                                                            id: seat2I
                                                            x: 773
                                                            y: 366
                                                            seatNumber: "2I"
                                                        }

                                                        SeatButton {
                                                            id: seat3I
                                                            x: 773
                                                            y: 404
                                                            seatNumber: "3I"
                                                        }

                                                        SeatButton {
                                                            id: seat4I
                                                            x: 773
                                                            y: 477
                                                            seatNumber: "4I"
                                                        }

                                                        SeatButton {
                                                            id: seat5I
                                                            x: 773
                                                            y: 516
                                                            seatNumber: "5I"
                                                        }

                                                        SeatButton {
                                                            id: seat6I
                                                            x: 773
                                                            y: 554
                                                            seatNumber: "6I"
                                                        }

                                                        // Center-left section - Column 1 (J seats)
                                                        SeatButton {
                                                            id: seat1J
                                                            x: 737
                                                            y: 327
                                                            seatNumber: "1J"
                                                        }

                                                        SeatButton {
                                                            id: seat2J
                                                            x: 737
                                                            y: 366
                                                            seatNumber: "2J"
                                                        }

                                                        SeatButton {
                                                            id: seat3J
                                                            x: 737
                                                            y: 404
                                                            seatNumber: "3J"
                                                        }

                                                        SeatButton {
                                                            id: seat4J
                                                            x: 737
                                                            y: 477
                                                            seatNumber: "4J"
                                                        }

                                                        SeatButton {
                                                            id: seat5J
                                                            x: 737
                                                            y: 516
                                                            seatNumber: "5J"
                                                        }

                                                        SeatButton {
                                                            id: seat6J
                                                            x: 737
                                                            y: 554
                                                            seatNumber: "6J"
                                                        }

                                                        // Center-left section - Column 2 (K seats)
                                                        SeatButton {
                                                            id: seat1K
                                                            x: 698
                                                            y: 327
                                                            seatNumber: "1K"
                                                        }

                                                        SeatButton {
                                                            id: seat2K
                                                            x: 698
                                                            y: 366
                                                            seatNumber: "2K"
                                                        }

                                                        SeatButton {
                                                            id: seat3K
                                                            x: 698
                                                            y: 404
                                                            seatNumber: "3K"
                                                        }

                                                        SeatButton {
                                                            id: seat4K
                                                            x: 698
                                                            y: 477
                                                            seatNumber: "4K"
                                                        }

                                                        SeatButton {
                                                            id: seat5K
                                                            x: 698
                                                            y: 516
                                                            seatNumber: "5K"
                                                        }

                                                        SeatButton {
                                                            id: seat6K
                                                            x: 698
                                                            y: 554
                                                            seatNumber: "6K"
                                                        }

                                                        // Center-left section - Column 3 (L seats)
                                                        SeatButton {
                                                            id: seat1L
                                                            x: 659
                                                            y: 327
                                                            seatNumber: "1L"
                                                        }

                                                        SeatButton {
                                                            id: seat2L
                                                            x: 659
                                                            y: 366
                                                            seatNumber: "2L"
                                                        }

                                                        SeatButton {
                                                            id: seat3L
                                                            x: 659
                                                            y: 404
                                                            seatNumber: "3L"
                                                        }

                                                        SeatButton {
                                                            id: seat4L
                                                            x: 659
                                                            y: 477
                                                            seatNumber: "4L"
                                                        }

                                                        SeatButton {
                                                            id: seat5L
                                                            x: 659
                                                            y: 516
                                                            seatNumber: "5L"
                                                        }

                                                        SeatButton {
                                                            id: seat6L
                                                            x: 659
                                                            y: 554
                                                            seatNumber: "6L"
                                                        }

                                                        // Left section (larger seats) - Column 1 (M seats)
                                                        SeatButton {
                                                            id: seat1M
                                                            x: 580
                                                            y: 327
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "1M"
                                                        }

                                                        SeatButton {
                                                            id: seat2M
                                                            x: 580
                                                            y: 365
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "2M"
                                                        }

                                                        SeatButton {
                                                            id: seat3M
                                                            x: 580
                                                            y: 404
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "3M"
                                                        }

                                                        SeatButton {
                                                            id: seat4M
                                                            x: 580
                                                            y: 475
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "4M"
                                                        }

                                                        SeatButton {
                                                            id: seat5M
                                                            x: 580
                                                            y: 513
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "5M"
                                                        }

                                                        SeatButton {
                                                            id: seat6M
                                                            x: 580
                                                            y: 552
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "6M"
                                                        }

                                                        // Left section - Column 2 (N seats)
                                                        SeatButton {
                                                            id: seat1N
                                                            x: 530
                                                            y: 327
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "1N"
                                                        }

                                                        SeatButton {
                                                            id: seat2N
                                                            x: 530
                                                            y: 365
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "2N"
                                                        }

                                                        SeatButton {
                                                            id: seat3N
                                                            x: 530
                                                            y: 404
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "3N"
                                                        }

                                                        SeatButton {
                                                            id: seat4N
                                                            x: 530
                                                            y: 475
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "4N"
                                                        }

                                                        SeatButton {
                                                            id: seat5N
                                                            x: 530
                                                            y: 513
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "5N"
                                                        }

                                                        SeatButton {
                                                            id: seat6N
                                                            x: 530
                                                            y: 552
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "6N"
                                                        }

                                                        // Left section - Column 3 (O seats)
                                                        SeatButton {
                                                            id: seat1O
                                                            x: 480
                                                            y: 327
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "1O"
                                                        }

                                                        SeatButton {
                                                            id: seat2O
                                                            x: 480
                                                            y: 365
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "2O"
                                                        }

                                                        SeatButton {
                                                            id: seat3O
                                                            x: 480
                                                            y: 404
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "3O"
                                                        }

                                                        SeatButton {
                                                            id: seat4O
                                                            x: 480
                                                            y: 475
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "4O"
                                                        }

                                                        SeatButton {
                                                            id: seat5O
                                                            x: 480
                                                            y: 513
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "5O"
                                                        }

                                                        SeatButton {
                                                            id: seat6O
                                                            x: 480
                                                            y: 552
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "6O"
                                                        }

                                                        // Left section - Column 4 (P seats)
                                                        SeatButton {
                                                            id: seat1P
                                                            x: 430
                                                            y: 327
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "1P"
                                                        }

                                                        SeatButton {
                                                            id: seat2P
                                                            x: 430
                                                            y: 365
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "2P"
                                                        }

                                                        SeatButton {
                                                            id: seat3P
                                                            x: 430
                                                            y: 404
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "3P"
                                                        }

                                                        SeatButton {
                                                            id: seat4P
                                                            x: 430
                                                            y: 475
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "4P"
                                                        }

                                                        SeatButton {
                                                            id: seat5P
                                                            x: 430
                                                            y: 513
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "5P"
                                                        }

                                                        SeatButton {
                                                            id: seat6P
                                                            x: 430
                                                            y: 552
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "6P"
                                                        }

                                                        // Front section (larger rectangular seats) - Column 1 (Q seats)
                                                        SeatButton {
                                                            id: seat1Q
                                                            x: 315
                                                            y: 360
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "1Q"
                                                        }

                                                        SeatButton {
                                                            id: seat2Q
                                                            x: 315
                                                            y: 398
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "2Q"
                                                        }

                                                        SeatButton {
                                                            id: seat3Q
                                                            x: 315
                                                            y: 481
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "3Q"
                                                        }

                                                        SeatButton {
                                                            id: seat4Q
                                                            x: 315
                                                            y: 519
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "4Q"
                                                        }

                                                        // Front section - Column 2 (R seats)
                                                        SeatButton {
                                                            id: seat1R
                                                            x: 265
                                                            y: 360
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "1R"
                                                        }

                                                        SeatButton {
                                                            id: seat2R
                                                            x: 265
                                                            y: 398
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "2R"
                                                        }

                                                        SeatButton {
                                                            id: seat3R
                                                            x: 265
                                                            y: 481
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "3R"
                                                        }

                                                        SeatButton {
                                                            id: seat4R
                                                            x: 265
                                                            y: 519
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "4R"
                                                        }

                                                        // Front section - Column 3 (S seats)
                                                        SeatButton {
                                                            id: seat1S
                                                            x: 215
                                                            y: 360
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "1S"
                                                        }

                                                        SeatButton {
                                                            id: seat2S
                                                            x: 215
                                                            y: 398
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "2S"
                                                        }

                                                        SeatButton {
                                                            id: seat3S
                                                            x: 215
                                                            y: 481
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "3S"
                                                        }

                                                        SeatButton {
                                                            id: seat4S
                                                            x: 215
                                                            y: 519
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "4S"
                                                        }

                                                        // Far right single column seats (T seats)
                                                        SeatButton {
                                                            id: seat1T
                                                            x: 1117
                                                            y: 366
                                                            seatNumber: "1T"
                                                        }

                                                        SeatButton {
                                                            id: seat2T
                                                            x: 1117
                                                            y: 405
                                                            seatNumber: "2T"
                                                        }

                                                        SeatButton {
                                                            id: seat3T
                                                            x: 1117
                                                            y: 477
                                                            seatNumber: "3T"
                                                        }

                                                        SeatButton {
                                                            id: seat4T
                                                            x: 1117
                                                            y: 516
                                                            seatNumber: "4T"
                                                        }
                                                    }
                                                }
                                            }

                                            // Booking confirmation
                                            Rectangle {
                                                width: 700
                                                height: 180
                                                color: "#161b22"
                                                radius: 12
                                                border.color: "#30363d"
                                                border.width: 1
                                                visible: seatSelectionView.selectedSeatId !== ""

                                                Column {
                                                    anchors.centerIn: parent
                                                    spacing: 15
                                                    width: parent.width - 60

                                                    Text {
                                                        text: "Selected Seat: " + seatSelectionView.selectedSeatId
                                                        color: "white"
                                                        font.pixelSize: 22
                                                        font.bold: true
                                                        anchors.horizontalCenter: parent.horizontalCenter
                                                    }

                                                    TextField {
                                                        id: passengerNameInput
                                                        width: 400
                                                        height: 45
                                                        placeholderText: "Enter passenger name"
                                                        font.pixelSize: 15
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
                                                        width: 250
                                                        height: 45
                                                        anchors.horizontalCenter: parent.horizontalCenter
                                                        enabled: passengerNameInput.text.length > 0

                                                        background: Rectangle {
                                                            color: parent.enabled ? (parent.hovered ? "#1f6feb" : "#0969da") : "#30363d"
                                                            radius: 8
                                                        }

                                                        contentItem: Text {
                                                            text: parent.text
                                                            color: parent.enabled ? "white" : "#6e7681"
                                                            font.pixelSize: 15
                                                            font.bold: true
                                                            horizontalAlignment: Text.AlignHCenter
                                                            verticalAlignment: Text.AlignVCenter
                                                        }

                                                        onClicked: {
                                                            var bookingId = flightHandler.bookFlight(
                                                                selectedFlight.flightNumber,
                                                                passengerNameInput.text,
                                                                seatSelectionView.selectedSeatId
                                                            )
                                                            console.log("Booking confirmed! ID:", bookingId)
                                                            console.log("Flight:", selectedFlight.flightNumber)
                                                            console.log("Seat:", seatSelectionView.selectedSeatId)
                                                            console.log("Passenger:", passengerNameInput.text)

                                                            currentView = "flights"
                                                            seatSelectionView.selectedSeatId = ""
                                                            passengerNameInput.text = ""
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
            }
        }
    }
}
