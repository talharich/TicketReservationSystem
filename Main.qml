import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    width: 1920
    height: 1080
    visible: true
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
                width: 250
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
                        width: parent.width
                        height: 2
                        color: "#30363d"
                    }

                    Button {
                        text: "Logout"
                        width: parent.width
                        height: 45

                        background: Rectangle {
                            color: parent.hovered ? "#da3633" : "#0f1419"
                            radius: 6
                            border.color: "#f85149"
                            border.width: 1
                        }

                        contentItem: Text {
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
                    property int selectedSeat: -1

                    // Load booked seats when view becomes visible
                    onVisibleChanged: {
                        if (visible && selectedFlight) {
                            bookedSeats = flightHandler.getBookedSeats(selectedFlight.flightNumber)
                            selectedSeat = -1
                        }
                    }

                    function isSeatBooked(seatIndex) {
                        return bookedSeats.indexOf(seatIndex) !== -1
                    }

                    ScrollView {
                        anchors.fill: parent
                        clip: true

                        Column {
                            width: parent.width - 60
                            spacing: 30

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
                                    seatSelectionView.selectedSeat = -1
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

                                    Column {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        spacing: 15

                                        Repeater {
                                            model: 10

                                            Row {
                                                spacing: 20
                                                property int rowNum: index

                                                Text {
                                                    text: (rowNum + 1).toString()
                                                    color: "#7d8590"
                                                    font.pixelSize: 16
                                                    font.bold: true
                                                    width: 30
                                                    anchors.verticalCenter: parent.verticalCenter
                                                }

                                                Repeater {
                                                    model: 3
                                                    Rectangle {
                                                        width: 60
                                                        height: 60
                                                        radius: 8

                                                        property int seatIndex: parent.rowNum * 6 + index
                                                        property bool isBooked: seatSelectionView.seatStatus[seatIndex] === 1
                                                        property bool isSelected: seatSelectionView.selectedSeat === seatIndex

                                                        color: isSelected ? "#58a6ff" : (isBooked ? "#6e7681" : "#0f1419")
                                                        border.color: isSelected ? "#58a6ff" : (isBooked ? "#6e7681" : "#3fb950")
                                                        border.width: 2

                                                        Text {
                                                            anchors.centerIn: parent
                                                            text: String.fromCharCode(65 + index)
                                                            color: parent.isBooked ? "#484f58" : "white"
                                                            font.pixelSize: 18
                                                            font.bold: true
                                                        }

                                                        MouseArea {
                                                            anchors.fill: parent
                                                            enabled: !parent.isBooked
                                                            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
                                                            onClicked: {
                                                                seatSelectionView.selectedSeat = parent.seatIndex
                                                            }
                                                        }
                                                    }
                                                }

                                                Item { width: 40; height: 60 }

                                                Repeater {
                                                    model: 3
                                                    Rectangle {
                                                        width: 60
                                                        height: 60
                                                        radius: 8

                                                        property int seatIndex: parent.rowNum * 6 + 3 + index
                                                        property bool isBooked: seatSelectionView.seatStatus[seatIndex] === 1
                                                        property bool isSelected: seatSelectionView.selectedSeat === seatIndex

                                                        color: isSelected ? "#58a6ff" : (isBooked ? "#6e7681" : "#0f1419")
                                                        border.color: isSelected ? "#58a6ff" : (isBooked ? "#6e7681" : "#3fb950")
                                                        border.width: 2

                                                        Text {
                                                            anchors.centerIn: parent
                                                            text: String.fromCharCode(68 + index)
                                                            color: parent.isBooked ? "#484f58" : "white"
                                                            font.pixelSize: 18
                                                            font.bold: true
                                                        }

                                                        MouseArea {
                                                            anchors.fill: parent
                                                            enabled: !parent.isBooked
                                                            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
                                                            onClicked: {
                                                                seatSelectionView.selectedSeat = parent.seatIndex
                                                            }
                                                        }
                                                    }
                                                }

                                                Text {
                                                    text: (parent.rowNum + 1).toString()
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

                            // Booking confirmation
                            Rectangle {
                                width: 700
                                height: 200
                                color: "#161b22"
                                radius: 12
                                border.color: "#30363d"
                                border.width: 1
                                anchors.horizontalCenter: parent.horizontalCenter
                                visible: seatSelectionView.selectedSeat >= 0

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 20
                                    width: parent.width - 60

                                    Text {
                                        text: "Selected Seat: " + (seatSelectionView.selectedSeat >= 0 ? (Math.floor(seatSelectionView.selectedSeat / 6) + 1) + String.fromCharCode(65 + (seatSelectionView.selectedSeat % 6)) : "None")
                                        color: "white"
                                        font.pixelSize: 24
                                        font.bold: true
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }

                                    TextField {
                                        id: passengerNameInput
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
                                        enabled: passengerNameInput.text.length > 0

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
                                            console.log("Flight:", selectedFlight.flightNumber)
                                            console.log("Seat:", Math.floor(seatSelectionView.selectedSeat / 6) + 1 + String.fromCharCode(65 + (seatSelectionView.selectedSeat % 6)))
                                            console.log("Passenger:", passengerNameInput.text)

                                            // Show success message and go back
                                            currentView = "flights"
                                            seatSelectionView.selectedSeat = -1
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
