import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    width: 1920
    height: 1080
    visible: true
    visibility: Window.Maximized
    title: "Airline Reservation System"

    property bool isLoggedIn: false
    property string currentUsername: ""  // ADD THIS LINE
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
                                currentUsername = usernameField.text  // ADD THIS LINE
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
                            currentUsername = ""
                            currentView = "flights"
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
                ScrollView {
                    id: bookingsScrollView
                    anchors.fill: parent
                    anchors.margins: 30
                    visible: currentView === "bookings"
                    clip: true

                    property var myBookings: []

                    // Load bookings when view becomes visible
                    onVisibleChanged: {
                        if (visible) {
                            myBookings = flightHandler.getMyBookings(currentUsername)
                            console.log("Loaded bookings:", myBookings.length)
                        }
                    }

                    Column {
                        width: parent.width - 60
                        spacing: 20

                        Text {
                            text: "My Bookings"
                            color: "white"
                            font.pixelSize: 32
                            font.bold: true
                        }

                        // Bookings List
                        Repeater {
                            model: bookingsScrollView.myBookings
                            delegate: Rectangle {
                                width: 1100
                                height: 150
                                color: "#161b22"
                                radius: 12
                                border.color: "#30363d"
                                border.width: 1

                                property var bookingData: modelData

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 25
                                    spacing: 15

                                    // Booking header
                                    Row {
                                        width: parent.width
                                        spacing: 20

                                        Column {
                                            spacing: 5
                                            width: 200
                                            Text {
                                                text: "Booking ID"
                                                color: "#7d8590"
                                                font.pixelSize: 12
                                            }
                                            Text {
                                                text: bookingData.bookingId
                                                color: "#58a6ff"
                                                font.pixelSize: 18
                                                font.bold: true
                                            }
                                        }

                                        Rectangle {
                                            width: 1
                                            height: 50
                                            color: "#30363d"
                                        }

                                        Column {
                                            spacing: 5
                                            width: 150
                                            Text {
                                                text: "Flight"
                                                color: "#7d8590"
                                                font.pixelSize: 12
                                            }
                                            Text {
                                                text: bookingData.flightNumber
                                                color: "white"
                                                font.pixelSize: 18
                                                font.bold: true
                                            }
                                        }

                                        Rectangle {
                                            width: 1
                                            height: 50
                                            color: "#30363d"
                                        }

                                        Column {
                                            spacing: 5
                                            width: 100
                                            Text {
                                                text: "Seat"
                                                color: "#7d8590"
                                                font.pixelSize: 12
                                            }
                                            Text {
                                                text: bookingData.seatId
                                                color: "#3fb950"
                                                font.pixelSize: 18
                                                font.bold: true
                                            }
                                        }

                                        Rectangle {
                                            width: 1
                                            height: 50
                                            color: "#30363d"
                                        }

                                        Column {
                                            spacing: 5
                                            width: 250
                                            Text {
                                                text: "Passenger"
                                                color: "#7d8590"
                                                font.pixelSize: 12
                                            }
                                            Text {
                                                text: bookingData.passengerName
                                                color: "white"
                                                font.pixelSize: 18
                                            }
                                        }

                                        Item {
                                            width: 50
                                            height: 1
                                        }

                                        Button {
                                            text: "Cancel Booking"
                                            width: 150
                                            height: 45
                                            anchors.verticalCenter: parent.verticalCenter

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
                                                font.bold: true
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                            }

                                            onClicked: {
                                                cancelDialog.bookingToCancel = bookingData
                                                cancelDialog.visible = true
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Empty state - shows when no bookings
                        Rectangle {
                            width: 400
                            height: 300
                            color: "transparent"
                            visible: bookingsScrollView.myBookings.length === 0
                            anchors.horizontalCenter: parent.horizontalCenter

                            Column {
                                anchors.centerIn: parent
                                spacing: 20

                                Text {
                                    text: "📋"
                                    color: "#30363d"
                                    font.pixelSize: 80
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "No bookings yet"
                                    color: "#7d8590"
                                    font.pixelSize: 24
                                    font.bold: true
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "Book a flight to see it here"
                                    color: "#484f58"
                                    font.pixelSize: 16
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }

                    // Cancel Confirmation Dialog
                    Rectangle {
                        id: cancelDialog
                        anchors.fill: parent
                        color: "#000000cc"
                        visible: false
                        z: 1000

                        property var bookingToCancel: null

                        MouseArea {
                            anchors.fill: parent
                            onClicked: cancelDialog.visible = false
                        }

                        Rectangle {
                            anchors.centerIn: parent
                            width: 500
                            height: 280
                            color: "#161b22"
                            radius: 12
                            border.color: "#30363d"
                            border.width: 1

                            Column {
                                anchors.centerIn: parent
                                spacing: 25
                                width: parent.width - 60

                                Text {
                                    text: "⚠ Cancel Booking"
                                    color: "white"
                                    font.pixelSize: 24
                                    font.bold: true
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "Are you sure you want to cancel this booking?"
                                    color: "#7d8590"
                                    font.pixelSize: 16
                                    width: parent.width
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignHCenter
                                }

                                Column {
                                    spacing: 5
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    Text {
                                        text: cancelDialog.bookingToCancel ? "Booking ID: " + cancelDialog.bookingToCancel.bookingId : ""
                                        color: "#58a6ff"
                                        font.pixelSize: 14
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                    Text {
                                        text: cancelDialog.bookingToCancel ? "Flight: " + cancelDialog.bookingToCancel.flightNumber + " | Seat: " + cancelDialog.bookingToCancel.seatId : ""
                                        color: "white"
                                        font.pixelSize: 14
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }

                                Row {
                                    spacing: 15
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    Button {
                                        text: "No, Keep It"
                                        width: 150
                                        height: 45

                                        background: Rectangle {
                                            color: parent.hovered ? "#1c2128" : "transparent"
                                            radius: 6
                                            border.color: "#30363d"
                                            border.width: 1
                                        }

                                        contentItem: Text {
                                            text: parent.text
                                            color: "white"
                                            font.pixelSize: 14
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        onClicked: {
                                            cancelDialog.visible = false
                                        }
                                    }

                                    Button {
                                        text: "Yes, Cancel"
                                        width: 150
                                        height: 45

                                        background: Rectangle {
                                            color: parent.hovered ? "#da3633" : "#f85149"
                                            radius: 6
                                        }

                                        contentItem: Text {
                                            text: parent.text
                                            color: "white"
                                            font.pixelSize: 14
                                            font.bold: true
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        onClicked: {
                                            var success = flightHandler.cancelBooking(cancelDialog.bookingToCancel.bookingId)

                                            if (success) {
                                                console.log("Booking cancelled successfully")
                                                // Reload bookings
                                                bookingsScrollView.myBookings = flightHandler.getMyBookings(currentUsername)  // USE ID
                                                flightsList = flightHandler.getAllFlights()
                                            } else {
                                                console.log("Failed to cancel booking")
                                            }

                                            cancelDialog.visible = false
                                        }
                                    }
                                }
                            }
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
                                    passengerNameInput.text = ""
                                    bookingStatusText.visible = false
                                }
                            }

                            // Reset status message when seat selection changes
                            onSelectedSeatIdChanged: {
                                bookingStatusText.visible = false
                            }

                            function isSeatBooked(seatId) {
                                return bookedSeats.indexOf(seatId) !== -1
                            }

                            function handleSeatClick(seatId) {
                                // Don't allow selecting booked seats
                                if (isSeatBooked(seatId)) {
                                    // Show feedback that seat is unavailable
                                    console.log("Seat", seatId, "is already booked")
                                    return
                                }

                                // Toggle selection: if clicking the same seat, deselect it
                                if (selectedSeatId === seatId) {
                                    selectedSeatId = ""
                                    // Clear passenger name when deselecting
                                    passengerNameInput.text = ""
                                } else {
                                    selectedSeatId = seatId
                                }
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
                                                    passengerNameInput.text = ""
                                                    bookingStatusText.visible = false
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

                                                Item {
                                                    width: 1920
                                                    height: 1080
                                                    x: -120
                                                    y: -70
                                                    scale: 0.75
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
                                                            x: 1081
                                                            y: 327
                                                            seatNumber: "1A"
                                                            isBooked: seatSelectionView.isSeatBooked("1A")
                                                            isSelected: seatSelectionView.selectedSeatId === "1A"
                                                            onClicked: seatSelectionView.handleSeatClick("1A")
                                                        }

                                                        SeatButton {
                                                            x: 1081
                                                            y: 366
                                                            seatNumber: "2A"
                                                            isBooked: seatSelectionView.isSeatBooked("2A")
                                                            isSelected: seatSelectionView.selectedSeatId === "2A"
                                                            onClicked: seatSelectionView.handleSeatClick("2A")
                                                        }

                                                        SeatButton {
                                                            x: 1081
                                                            y: 404
                                                            seatNumber: "3A"
                                                            isBooked: seatSelectionView.isSeatBooked("3A")
                                                            isSelected: seatSelectionView.selectedSeatId === "3A"
                                                            onClicked: seatSelectionView.handleSeatClick("3A")
                                                        }

                                                        SeatButton {
                                                            x: 1081
                                                            y: 477
                                                            seatNumber: "4A"
                                                            isBooked: seatSelectionView.isSeatBooked("4A")
                                                            isSelected: seatSelectionView.selectedSeatId === "4A"
                                                            onClicked: seatSelectionView.handleSeatClick("4A")
                                                        }

                                                        SeatButton {
                                                            x: 1081
                                                            y: 516
                                                            seatNumber: "5A"
                                                            isBooked: seatSelectionView.isSeatBooked("5A")
                                                            isSelected: seatSelectionView.selectedSeatId === "5A"
                                                            onClicked: seatSelectionView.handleSeatClick("5A")
                                                        }

                                                        SeatButton {
                                                            x: 1081
                                                            y: 554
                                                            seatNumber: "6A"
                                                            isBooked: seatSelectionView.isSeatBooked("6A")
                                                            isSelected: seatSelectionView.selectedSeatId === "6A"
                                                            onClicked: seatSelectionView.handleSeatClick("6A")
                                                        }

                                                        // Right section - Column 2 (B seats)
                                                        SeatButton {
                                                            x: 1042
                                                            y: 327
                                                            seatNumber: "1B"
                                                            isBooked: seatSelectionView.isSeatBooked("1B")
                                                            isSelected: seatSelectionView.selectedSeatId === "1B"
                                                            onClicked: seatSelectionView.handleSeatClick("1B")
                                                        }

                                                        SeatButton {
                                                            x: 1042
                                                            y: 366
                                                            seatNumber: "2B"
                                                            isBooked: seatSelectionView.isSeatBooked("2B")
                                                            isSelected: seatSelectionView.selectedSeatId === "2B"
                                                            onClicked: seatSelectionView.handleSeatClick("2B")
                                                        }

                                                        SeatButton {
                                                            x: 1042
                                                            y: 404
                                                            seatNumber: "3B"
                                                            isBooked: seatSelectionView.isSeatBooked("3B")
                                                            isSelected: seatSelectionView.selectedSeatId === "3B"
                                                            onClicked: seatSelectionView.handleSeatClick("3B")
                                                        }

                                                        SeatButton {
                                                            x: 1042
                                                            y: 477
                                                            seatNumber: "4B"
                                                            isBooked: seatSelectionView.isSeatBooked("4B")
                                                            isSelected: seatSelectionView.selectedSeatId === "4B"
                                                            onClicked: seatSelectionView.handleSeatClick("4B")
                                                        }

                                                        SeatButton {
                                                            x: 1042
                                                            y: 516
                                                            seatNumber: "5B"
                                                            isBooked: seatSelectionView.isSeatBooked("5B")
                                                            isSelected: seatSelectionView.selectedSeatId === "5B"
                                                            onClicked: seatSelectionView.handleSeatClick("5B")
                                                        }

                                                        SeatButton {
                                                            x: 1042
                                                            y: 554
                                                            seatNumber: "6B"
                                                            isBooked: seatSelectionView.isSeatBooked("6B")
                                                            isSelected: seatSelectionView.selectedSeatId === "6B"
                                                            onClicked: seatSelectionView.handleSeatClick("6B")
                                                        }

                                                        // Right section - Column 3 (C seats)
                                                        SeatButton {
                                                            x: 1003
                                                            y: 327
                                                            seatNumber: "1C"
                                                            isBooked: seatSelectionView.isSeatBooked("1C")
                                                            isSelected: seatSelectionView.selectedSeatId === "1C"
                                                            onClicked: seatSelectionView.handleSeatClick("1C")
                                                        }

                                                        SeatButton {
                                                            x: 1003
                                                            y: 366
                                                            seatNumber: "2C"
                                                            isBooked: seatSelectionView.isSeatBooked("2C")
                                                            isSelected: seatSelectionView.selectedSeatId === "2C"
                                                            onClicked: seatSelectionView.handleSeatClick("2C")
                                                        }

                                                        SeatButton {
                                                            x: 1003
                                                            y: 404
                                                            seatNumber: "3C"
                                                            isBooked: seatSelectionView.isSeatBooked("3C")
                                                            isSelected: seatSelectionView.selectedSeatId === "3C"
                                                            onClicked: seatSelectionView.handleSeatClick("3C")
                                                        }

                                                        SeatButton {
                                                            x: 1003
                                                            y: 477
                                                            seatNumber: "4C"
                                                            isBooked: seatSelectionView.isSeatBooked("4C")
                                                            isSelected: seatSelectionView.selectedSeatId === "4C"
                                                            onClicked: seatSelectionView.handleSeatClick("4C")
                                                        }

                                                        SeatButton {
                                                            x: 1003
                                                            y: 516
                                                            seatNumber: "5C"
                                                            isBooked: seatSelectionView.isSeatBooked("5C")
                                                            isSelected: seatSelectionView.selectedSeatId === "5C"
                                                            onClicked: seatSelectionView.handleSeatClick("5C")
                                                        }

                                                        SeatButton {
                                                            x: 1003
                                                            y: 554
                                                            seatNumber: "6C"
                                                            isBooked: seatSelectionView.isSeatBooked("6C")
                                                            isSelected: seatSelectionView.selectedSeatId === "6C"
                                                            onClicked: seatSelectionView.handleSeatClick("6C")
                                                        }

                                                        // Right-middle section - Column 1 (D seats)
                                                        SeatButton {
                                                            x: 967
                                                            y: 327
                                                            seatNumber: "1D"
                                                            isBooked: seatSelectionView.isSeatBooked("1D")
                                                            isSelected: seatSelectionView.selectedSeatId === "1D"
                                                            onClicked: seatSelectionView.handleSeatClick("1D")
                                                        }

                                                        SeatButton {
                                                            x: 967
                                                            y: 366
                                                            seatNumber: "2D"
                                                            isBooked: seatSelectionView.isSeatBooked("2D")
                                                            isSelected: seatSelectionView.selectedSeatId === "2D"
                                                            onClicked: seatSelectionView.handleSeatClick("2D")
                                                        }

                                                        SeatButton {
                                                            x: 967
                                                            y: 404
                                                            seatNumber: "3D"
                                                            isBooked: seatSelectionView.isSeatBooked("3D")
                                                            isSelected: seatSelectionView.selectedSeatId === "3D"
                                                            onClicked: seatSelectionView.handleSeatClick("3D")
                                                        }

                                                        SeatButton {
                                                            x: 967
                                                            y: 477
                                                            seatNumber: "4D"
                                                            isBooked: seatSelectionView.isSeatBooked("4D")
                                                            isSelected: seatSelectionView.selectedSeatId === "4D"
                                                            onClicked: seatSelectionView.handleSeatClick("4D")
                                                        }

                                                        SeatButton {
                                                            x: 967
                                                            y: 516
                                                            seatNumber: "5D"
                                                            isBooked: seatSelectionView.isSeatBooked("5D")
                                                            isSelected: seatSelectionView.selectedSeatId === "5D"
                                                            onClicked: seatSelectionView.handleSeatClick("5D")
                                                        }

                                                        SeatButton {
                                                            x: 967
                                                            y: 554
                                                            seatNumber: "6D"
                                                            isBooked: seatSelectionView.isSeatBooked("6D")
                                                            isSelected: seatSelectionView.selectedSeatId === "6D"
                                                            onClicked: seatSelectionView.handleSeatClick("6D")
                                                        }

                                                        // Right-middle section - Column 2 (E seats)
                                                        SeatButton {
                                                            x: 928
                                                            y: 327
                                                            seatNumber: "1E"
                                                            isBooked: seatSelectionView.isSeatBooked("1E")
                                                            isSelected: seatSelectionView.selectedSeatId === "1E"
                                                            onClicked: seatSelectionView.handleSeatClick("1E")
                                                        }

                                                        SeatButton {
                                                            x: 928
                                                            y: 366
                                                            seatNumber: "2E"
                                                            isBooked: seatSelectionView.isSeatBooked("2E")
                                                            isSelected: seatSelectionView.selectedSeatId === "2E"
                                                            onClicked: seatSelectionView.handleSeatClick("2E")
                                                        }

                                                        SeatButton {
                                                            x: 928
                                                            y: 404
                                                            seatNumber: "3E"
                                                            isBooked: seatSelectionView.isSeatBooked("3E")
                                                            isSelected: seatSelectionView.selectedSeatId === "3E"
                                                            onClicked: seatSelectionView.handleSeatClick("3E")
                                                        }

                                                        SeatButton {
                                                            x: 928
                                                            y: 477
                                                            seatNumber: "4E"
                                                            isBooked: seatSelectionView.isSeatBooked("4E")
                                                            isSelected: seatSelectionView.selectedSeatId === "4E"
                                                            onClicked: seatSelectionView.handleSeatClick("4E")
                                                        }

                                                        SeatButton {
                                                            x: 928
                                                            y: 516
                                                            seatNumber: "5E"
                                                            isBooked: seatSelectionView.isSeatBooked("5E")
                                                            isSelected: seatSelectionView.selectedSeatId === "5E"
                                                            onClicked: seatSelectionView.handleSeatClick("5E")
                                                        }

                                                        SeatButton {
                                                            x: 928
                                                            y: 554
                                                            seatNumber: "6E"
                                                            isBooked: seatSelectionView.isSeatBooked("6E")
                                                            isSelected: seatSelectionView.selectedSeatId === "6E"
                                                            onClicked: seatSelectionView.handleSeatClick("6E")
                                                        }

                                                        // Right-middle section - Column 3 (F seats)
                                                        SeatButton {
                                                            x: 889
                                                            y: 327
                                                            seatNumber: "1F"
                                                            isBooked: seatSelectionView.isSeatBooked("1F")
                                                            isSelected: seatSelectionView.selectedSeatId === "1F"
                                                            onClicked: seatSelectionView.handleSeatClick("1F")
                                                        }

                                                        SeatButton {
                                                            x: 889
                                                            y: 366
                                                            seatNumber: "2F"
                                                            isBooked: seatSelectionView.isSeatBooked("2F")
                                                            isSelected: seatSelectionView.selectedSeatId === "2F"
                                                            onClicked: seatSelectionView.handleSeatClick("2F")
                                                        }

                                                        SeatButton {
                                                            x: 889
                                                            y: 404
                                                            seatNumber: "3F"
                                                            isBooked: seatSelectionView.isSeatBooked("3F")
                                                            isSelected: seatSelectionView.selectedSeatId === "3F"
                                                            onClicked: seatSelectionView.handleSeatClick("3F")
                                                        }

                                                        SeatButton {
                                                            x: 889
                                                            y: 477
                                                            seatNumber: "4F"
                                                            isBooked: seatSelectionView.isSeatBooked("4F")
                                                            isSelected: seatSelectionView.selectedSeatId === "4F"
                                                            onClicked: seatSelectionView.handleSeatClick("4F")
                                                        }

                                                        SeatButton {
                                                            x: 889
                                                            y: 516
                                                            seatNumber: "5F"
                                                            isBooked: seatSelectionView.isSeatBooked("5F")
                                                            isSelected: seatSelectionView.selectedSeatId === "5F"
                                                            onClicked: seatSelectionView.handleSeatClick("5F")
                                                        }

                                                        SeatButton {
                                                            x: 889
                                                            y: 554
                                                            seatNumber: "6F"
                                                            isBooked: seatSelectionView.isSeatBooked("6F")
                                                            isSelected: seatSelectionView.selectedSeatId === "6F"
                                                            onClicked: seatSelectionView.handleSeatClick("6F")
                                                        }

                                                        // Center-right section - Column 1 (G seats)
                                                        SeatButton {
                                                            x: 851
                                                            y: 327
                                                            seatNumber: "1G"
                                                            isBooked: seatSelectionView.isSeatBooked("1G")
                                                            isSelected: seatSelectionView.selectedSeatId === "1G"
                                                            onClicked: seatSelectionView.handleSeatClick("1G")
                                                        }

                                                        SeatButton {
                                                            x: 851
                                                            y: 366
                                                            seatNumber: "2G"
                                                            isBooked: seatSelectionView.isSeatBooked("2G")
                                                            isSelected: seatSelectionView.selectedSeatId === "2G"
                                                            onClicked: seatSelectionView.handleSeatClick("2G")
                                                        }

                                                        SeatButton {
                                                            x: 851
                                                            y: 404
                                                            seatNumber: "3G"
                                                            isBooked: seatSelectionView.isSeatBooked("3G")
                                                            isSelected: seatSelectionView.selectedSeatId === "3G"
                                                            onClicked: seatSelectionView.handleSeatClick("3G")
                                                        }

                                                        SeatButton {
                                                            x: 851
                                                            y: 477
                                                            seatNumber: "4G"
                                                            isBooked: seatSelectionView.isSeatBooked("4G")
                                                            isSelected: seatSelectionView.selectedSeatId === "4G"
                                                            onClicked: seatSelectionView.handleSeatClick("4G")
                                                        }

                                                        SeatButton {
                                                            x: 851
                                                            y: 516
                                                            seatNumber: "5G"
                                                            isBooked: seatSelectionView.isSeatBooked("5G")
                                                            isSelected: seatSelectionView.selectedSeatId === "5G"
                                                            onClicked: seatSelectionView.handleSeatClick("5G")
                                                        }

                                                        SeatButton {
                                                            x: 851
                                                            y: 554
                                                            seatNumber: "6G"
                                                            isBooked: seatSelectionView.isSeatBooked("6G")
                                                            isSelected: seatSelectionView.selectedSeatId === "6G"
                                                            onClicked: seatSelectionView.handleSeatClick("6G")
                                                        }

                                                        // Center-right section - Column 2 (H seats)
                                                        SeatButton {
                                                            x: 812
                                                            y: 327
                                                            seatNumber: "1H"
                                                            isBooked: seatSelectionView.isSeatBooked("1H")
                                                            isSelected: seatSelectionView.selectedSeatId === "1H"
                                                            onClicked: seatSelectionView.handleSeatClick("1H")
                                                        }

                                                        SeatButton {
                                                            x: 812
                                                            y: 366
                                                            seatNumber: "2H"
                                                            isBooked: seatSelectionView.isSeatBooked("2H")
                                                            isSelected: seatSelectionView.selectedSeatId === "2H"
                                                            onClicked: seatSelectionView.handleSeatClick("2H")
                                                        }

                                                        SeatButton {
                                                            x: 812
                                                            y: 404
                                                            seatNumber: "3H"
                                                            isBooked: seatSelectionView.isSeatBooked("3H")
                                                            isSelected: seatSelectionView.selectedSeatId === "3H"
                                                            onClicked: seatSelectionView.handleSeatClick("3H")
                                                        }

                                                        SeatButton {
                                                            x: 812
                                                            y: 477
                                                            seatNumber: "4H"
                                                            isBooked: seatSelectionView.isSeatBooked("4H")
                                                            isSelected: seatSelectionView.selectedSeatId === "4H"
                                                            onClicked: seatSelectionView.handleSeatClick("4H")
                                                        }

                                                        SeatButton {
                                                            x: 812
                                                            y: 516
                                                            seatNumber: "5H"
                                                            isBooked: seatSelectionView.isSeatBooked("5H")
                                                            isSelected: seatSelectionView.selectedSeatId === "5H"
                                                            onClicked: seatSelectionView.handleSeatClick("5H")
                                                        }

                                                        SeatButton {
                                                            x: 812
                                                            y: 554
                                                            seatNumber: "6H"
                                                            isBooked: seatSelectionView.isSeatBooked("6H")
                                                            isSelected: seatSelectionView.selectedSeatId === "6H"
                                                            onClicked: seatSelectionView.handleSeatClick("6H")
                                                        }

                                                        // Center-right section - Column 3 (I seats)
                                                        SeatButton {
                                                            x: 773
                                                            y: 327
                                                            seatNumber: "1I"
                                                            isBooked: seatSelectionView.isSeatBooked("1I")
                                                            isSelected: seatSelectionView.selectedSeatId === "1I"
                                                            onClicked: seatSelectionView.handleSeatClick("1I")
                                                        }

                                                        SeatButton {
                                                            x: 773
                                                            y: 366
                                                            seatNumber: "2I"
                                                            isBooked: seatSelectionView.isSeatBooked("2I")
                                                            isSelected: seatSelectionView.selectedSeatId === "2I"
                                                            onClicked: seatSelectionView.handleSeatClick("2I")
                                                        }

                                                        SeatButton {
                                                            x: 773
                                                            y: 404
                                                            seatNumber: "3I"
                                                            isBooked: seatSelectionView.isSeatBooked("3I")
                                                            isSelected: seatSelectionView.selectedSeatId === "3I"
                                                            onClicked: seatSelectionView.handleSeatClick("3I")
                                                        }

                                                        SeatButton {
                                                            x: 773
                                                            y: 477
                                                            seatNumber: "4I"
                                                            isBooked: seatSelectionView.isSeatBooked("4I")
                                                            isSelected: seatSelectionView.selectedSeatId === "4I"
                                                            onClicked: seatSelectionView.handleSeatClick("4I")
                                                        }

                                                        SeatButton {
                                                            x: 773
                                                            y: 516
                                                            seatNumber: "5I"
                                                            isBooked: seatSelectionView.isSeatBooked("5I")
                                                            isSelected: seatSelectionView.selectedSeatId === "5I"
                                                            onClicked: seatSelectionView.handleSeatClick("5I")
                                                        }

                                                        SeatButton {
                                                            x: 773
                                                            y: 554
                                                            seatNumber: "6I"
                                                            isBooked: seatSelectionView.isSeatBooked("6I")
                                                            isSelected: seatSelectionView.selectedSeatId === "6I"
                                                            onClicked: seatSelectionView.handleSeatClick("6I")
                                                        }

                                                        // Center-left section - Column 1 (J seats)
                                                        SeatButton {
                                                            x: 737
                                                            y: 327
                                                            seatNumber: "1J"
                                                            isBooked: seatSelectionView.isSeatBooked("1J")
                                                            isSelected: seatSelectionView.selectedSeatId === "1J"
                                                            onClicked: seatSelectionView.handleSeatClick("1J")
                                                        }

                                                        SeatButton {
                                                            x: 737
                                                            y: 366
                                                            seatNumber: "2J"
                                                            isBooked: seatSelectionView.isSeatBooked("2J")
                                                            isSelected: seatSelectionView.selectedSeatId === "2J"
                                                            onClicked: seatSelectionView.handleSeatClick("2J")
                                                        }

                                                        SeatButton {
                                                            x: 737
                                                            y: 404
                                                            seatNumber: "3J"
                                                            isBooked: seatSelectionView.isSeatBooked("3J")
                                                            isSelected: seatSelectionView.selectedSeatId === "3J"
                                                            onClicked: seatSelectionView.handleSeatClick("3J")
                                                        }

                                                        SeatButton {
                                                            x: 737
                                                            y: 477
                                                            seatNumber: "4J"
                                                            isBooked: seatSelectionView.isSeatBooked("4J")
                                                            isSelected: seatSelectionView.selectedSeatId === "4J"
                                                            onClicked: seatSelectionView.handleSeatClick("4J")
                                                        }

                                                        SeatButton {
                                                            x: 737
                                                            y: 516
                                                            seatNumber: "5J"
                                                            isBooked: seatSelectionView.isSeatBooked("5J")
                                                            isSelected: seatSelectionView.selectedSeatId === "5J"
                                                            onClicked: seatSelectionView.handleSeatClick("5J")
                                                        }

                                                        SeatButton {
                                                            x: 737
                                                            y: 554
                                                            seatNumber: "6J"
                                                            isBooked: seatSelectionView.isSeatBooked("6J")
                                                            isSelected: seatSelectionView.selectedSeatId === "6J"
                                                            onClicked: seatSelectionView.handleSeatClick("6J")
                                                        }

                                                        // Center-left section - Column 2 (K seats)
                                                        SeatButton {
                                                            x: 698
                                                            y: 327
                                                            seatNumber: "1K"
                                                            isBooked: seatSelectionView.isSeatBooked("1K")
                                                            isSelected: seatSelectionView.selectedSeatId === "1K"
                                                            onClicked: seatSelectionView.handleSeatClick("1K")
                                                        }

                                                        SeatButton {
                                                            x: 698
                                                            y: 366
                                                            seatNumber: "2K"
                                                            isBooked: seatSelectionView.isSeatBooked("2K")
                                                            isSelected: seatSelectionView.selectedSeatId === "2K"
                                                            onClicked: seatSelectionView.handleSeatClick("2K")
                                                        }

                                                        SeatButton {
                                                            x: 698
                                                            y: 404
                                                            seatNumber: "3K"
                                                            isBooked: seatSelectionView.isSeatBooked("3K")
                                                            isSelected: seatSelectionView.selectedSeatId === "3K"
                                                            onClicked: seatSelectionView.handleSeatClick("3K")
                                                        }

                                                        SeatButton {
                                                            x: 698
                                                            y: 477
                                                            seatNumber: "4K"
                                                            isBooked: seatSelectionView.isSeatBooked("4K")
                                                            isSelected: seatSelectionView.selectedSeatId === "4K"
                                                            onClicked: seatSelectionView.handleSeatClick("4K")
                                                        }

                                                        SeatButton {
                                                            x: 698
                                                            y: 516
                                                            seatNumber: "5K"
                                                            isBooked: seatSelectionView.isSeatBooked("5K")
                                                            isSelected: seatSelectionView.selectedSeatId === "5K"
                                                            onClicked: seatSelectionView.handleSeatClick("5K")
                                                        }

                                                        SeatButton {
                                                            x: 698
                                                            y: 554
                                                            seatNumber: "6K"
                                                            isBooked: seatSelectionView.isSeatBooked("6K")
                                                            isSelected: seatSelectionView.selectedSeatId === "6K"
                                                            onClicked: seatSelectionView.handleSeatClick("6K")
                                                        }

                                                        // Center-left section - Column 3 (L seats)
                                                        SeatButton {
                                                            x: 659
                                                            y: 327
                                                            seatNumber: "1L"
                                                            isBooked: seatSelectionView.isSeatBooked("1L")
                                                            isSelected: seatSelectionView.selectedSeatId === "1L"
                                                            onClicked: seatSelectionView.handleSeatClick("1L")
                                                        }

                                                        SeatButton {
                                                            x: 659
                                                            y: 366
                                                            seatNumber: "2L"
                                                            isBooked: seatSelectionView.isSeatBooked("2L")
                                                            isSelected: seatSelectionView.selectedSeatId === "2L"
                                                            onClicked: seatSelectionView.handleSeatClick("2L")
                                                        }

                                                        SeatButton {
                                                            x: 659
                                                            y: 404
                                                            seatNumber: "3L"
                                                            isBooked: seatSelectionView.isSeatBooked("3L")
                                                            isSelected: seatSelectionView.selectedSeatId === "3L"
                                                            onClicked: seatSelectionView.handleSeatClick("3L")
                                                        }

                                                        SeatButton {
                                                            x: 659
                                                            y: 477
                                                            seatNumber: "4L"
                                                            isBooked: seatSelectionView.isSeatBooked("4L")
                                                            isSelected: seatSelectionView.selectedSeatId === "4L"
                                                            onClicked: seatSelectionView.handleSeatClick("4L")
                                                        }

                                                        SeatButton {
                                                            x: 659
                                                            y: 516
                                                            seatNumber: "5L"
                                                            isBooked: seatSelectionView.isSeatBooked("5L")
                                                            isSelected: seatSelectionView.selectedSeatId === "5L"
                                                            onClicked: seatSelectionView.handleSeatClick("5L")
                                                        }

                                                        SeatButton {
                                                            x: 659
                                                            y: 554
                                                            seatNumber: "6L"
                                                            isBooked: seatSelectionView.isSeatBooked("6L")
                                                            isSelected: seatSelectionView.selectedSeatId === "6L"
                                                            onClicked: seatSelectionView.handleSeatClick("6L")
                                                        }

                                                        // Left section (larger seats) - Column 1 (M seats)
                                                        SeatButton {
                                                            x: 580
                                                            y: 327
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "1M"
                                                            isBooked: seatSelectionView.isSeatBooked("1M")
                                                            isSelected: seatSelectionView.selectedSeatId === "1M"
                                                            onClicked: seatSelectionView.handleSeatClick("1M")
                                                        }

                                                        SeatButton {
                                                            x: 580
                                                            y: 365
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "2M"
                                                            isBooked: seatSelectionView.isSeatBooked("2M")
                                                            isSelected: seatSelectionView.selectedSeatId === "2M"
                                                            onClicked: seatSelectionView.handleSeatClick("2M")
                                                        }

                                                        SeatButton {
                                                            x: 580
                                                            y: 404
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "3M"
                                                            isBooked: seatSelectionView.isSeatBooked("3M")
                                                            isSelected: seatSelectionView.selectedSeatId === "3M"
                                                            onClicked: seatSelectionView.handleSeatClick("3M")
                                                        }

                                                        SeatButton {
                                                            x: 580
                                                            y: 475
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "4M"
                                                            isBooked: seatSelectionView.isSeatBooked("4M")
                                                            isSelected: seatSelectionView.selectedSeatId === "4M"
                                                            onClicked: seatSelectionView.handleSeatClick("4M")
                                                        }

                                                        SeatButton {
                                                            x: 580
                                                            y: 513
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "5M"
                                                            isBooked: seatSelectionView.isSeatBooked("5M")
                                                            isSelected: seatSelectionView.selectedSeatId === "5M"
                                                            onClicked: seatSelectionView.handleSeatClick("5M")
                                                        }

                                                        SeatButton {
                                                            x: 580
                                                            y: 552
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "6M"
                                                            isBooked: seatSelectionView.isSeatBooked("6M")
                                                            isSelected: seatSelectionView.selectedSeatId === "6M"
                                                            onClicked: seatSelectionView.handleSeatClick("6M")
                                                        }

                                                        // Left section - Column 2 (N seats)
                                                        SeatButton {
                                                            x: 530
                                                            y: 327
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "1N"
                                                            isBooked: seatSelectionView.isSeatBooked("1N")
                                                            isSelected: seatSelectionView.selectedSeatId === "1N"
                                                            onClicked: seatSelectionView.handleSeatClick("1N")
                                                        }

                                                        SeatButton {
                                                            x: 530
                                                            y: 365
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "2N"
                                                            isBooked: seatSelectionView.isSeatBooked("2N")
                                                            isSelected: seatSelectionView.selectedSeatId === "2N"
                                                            onClicked: seatSelectionView.handleSeatClick("2N")
                                                        }

                                                        SeatButton {
                                                            x: 530
                                                            y: 404
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "3N"
                                                            isBooked: seatSelectionView.isSeatBooked("3N")
                                                            isSelected: seatSelectionView.selectedSeatId === "3N"
                                                            onClicked: seatSelectionView.handleSeatClick("3N")
                                                        }

                                                        SeatButton {
                                                            x: 530
                                                            y: 475
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "4N"
                                                            isBooked: seatSelectionView.isSeatBooked("4N")
                                                            isSelected: seatSelectionView.selectedSeatId === "4N"
                                                            onClicked: seatSelectionView.handleSeatClick("4N")
                                                        }

                                                        SeatButton {
                                                            x: 530
                                                            y: 513
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "5N"
                                                            isBooked: seatSelectionView.isSeatBooked("5N")
                                                            isSelected: seatSelectionView.selectedSeatId === "5N"
                                                            onClicked: seatSelectionView.handleSeatClick("5N")
                                                        }

                                                        SeatButton {
                                                            x: 530
                                                            y: 552
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "6N"
                                                            isBooked: seatSelectionView.isSeatBooked("6N")
                                                            isSelected: seatSelectionView.selectedSeatId === "6N"
                                                            onClicked: seatSelectionView.handleSeatClick("6N")
                                                        }

                                                        // Left section - Column 3 (O seats)
                                                        SeatButton {
                                                            x: 480
                                                            y: 327
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "1O"
                                                            isBooked: seatSelectionView.isSeatBooked("1O")
                                                            isSelected: seatSelectionView.selectedSeatId === "1O"
                                                            onClicked: seatSelectionView.handleSeatClick("1O")
                                                        }

                                                        SeatButton {
                                                            x: 480
                                                            y: 365
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "2O"
                                                            isBooked: seatSelectionView.isSeatBooked("2O")
                                                            isSelected: seatSelectionView.selectedSeatId === "2O"
                                                            onClicked: seatSelectionView.handleSeatClick("2O")
                                                        }

                                                        SeatButton {
                                                            x: 480
                                                            y: 404
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "3O"
                                                            isBooked: seatSelectionView.isSeatBooked("3O")
                                                            isSelected: seatSelectionView.selectedSeatId === "3O"
                                                            onClicked: seatSelectionView.handleSeatClick("3O")
                                                        }

                                                        SeatButton {
                                                            x: 480
                                                            y: 475
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "4O"
                                                            isBooked: seatSelectionView.isSeatBooked("4O")
                                                            isSelected: seatSelectionView.selectedSeatId === "4O"
                                                            onClicked: seatSelectionView.handleSeatClick("4O")
                                                        }

                                                        SeatButton {
                                                            x: 480
                                                            y: 513
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "5O"
                                                            isBooked: seatSelectionView.isSeatBooked("5O")
                                                            isSelected: seatSelectionView.selectedSeatId === "5O"
                                                            onClicked: seatSelectionView.handleSeatClick("5O")
                                                        }

                                                        SeatButton {
                                                            x: 480
                                                            y: 552
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "6O"
                                                            isBooked: seatSelectionView.isSeatBooked("6O")
                                                            isSelected: seatSelectionView.selectedSeatId === "6O"
                                                            onClicked: seatSelectionView.handleSeatClick("6O")
                                                        }

                                                        // Left section - Column 4 (P seats)
                                                        SeatButton {
                                                            x: 430
                                                            y: 327
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "1P"
                                                            isBooked: seatSelectionView.isSeatBooked("1P")
                                                            isSelected: seatSelectionView.selectedSeatId === "1P"
                                                            onClicked: seatSelectionView.handleSeatClick("1P")
                                                        }

                                                        SeatButton {
                                                            x: 430
                                                            y: 365
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "2P"
                                                            isBooked: seatSelectionView.isSeatBooked("2P")
                                                            isSelected: seatSelectionView.selectedSeatId === "2P"
                                                            onClicked: seatSelectionView.handleSeatClick("2P")
                                                        }

                                                        SeatButton {
                                                            x: 430
                                                            y: 404
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "3P"
                                                            isBooked: seatSelectionView.isSeatBooked("3P")
                                                            isSelected: seatSelectionView.selectedSeatId === "3P"
                                                            onClicked: seatSelectionView.handleSeatClick("3P")
                                                        }

                                                        SeatButton {
                                                            x: 430
                                                            y: 475
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "4P"
                                                            isBooked: seatSelectionView.isSeatBooked("4P")
                                                            isSelected: seatSelectionView.selectedSeatId === "4P"
                                                            onClicked: seatSelectionView.handleSeatClick("4P")
                                                        }

                                                        SeatButton {
                                                            x: 430
                                                            y: 513
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "5P"
                                                            isBooked: seatSelectionView.isSeatBooked("5P")
                                                            isSelected: seatSelectionView.selectedSeatId === "5P"
                                                            onClicked: seatSelectionView.handleSeatClick("5P")
                                                        }

                                                        SeatButton {
                                                            x: 430
                                                            y: 552
                                                            width: 35
                                                            height: 35
                                                            seatNumber: "6P"
                                                            isBooked: seatSelectionView.isSeatBooked("6P")
                                                            isSelected: seatSelectionView.selectedSeatId === "6P"
                                                            onClicked: seatSelectionView.handleSeatClick("6P")
                                                        }

                                                        // Front section (larger rectangular seats) - Column 1 (Q seats)
                                                        SeatButton {
                                                            x: 315
                                                            y: 360
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "1Q"
                                                            isBooked: seatSelectionView.isSeatBooked("1Q")
                                                            isSelected: seatSelectionView.selectedSeatId === "1Q"
                                                            onClicked: seatSelectionView.handleSeatClick("1Q")
                                                        }

                                                        SeatButton {
                                                            x: 315
                                                            y: 398
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "2Q"
                                                            isBooked: seatSelectionView.isSeatBooked("2Q")
                                                            isSelected: seatSelectionView.selectedSeatId === "2Q"
                                                            onClicked: seatSelectionView.handleSeatClick("2Q")
                                                        }

                                                        SeatButton {
                                                            x: 315
                                                            y: 481
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "3Q"
                                                            isBooked: seatSelectionView.isSeatBooked("3Q")
                                                            isSelected: seatSelectionView.selectedSeatId === "3Q"
                                                            onClicked: seatSelectionView.handleSeatClick("3Q")
                                                        }

                                                        SeatButton {
                                                            x: 315
                                                            y: 519
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "4Q"
                                                            isBooked: seatSelectionView.isSeatBooked("4Q")
                                                            isSelected: seatSelectionView.selectedSeatId === "4Q"
                                                            onClicked: seatSelectionView.handleSeatClick("4Q")
                                                        }

                                                        // Front section - Column 2 (R seats)
                                                        SeatButton {
                                                            x: 265
                                                            y: 360
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "1R"
                                                            isBooked: seatSelectionView.isSeatBooked("1R")
                                                            isSelected: seatSelectionView.selectedSeatId === "1R"
                                                            onClicked: seatSelectionView.handleSeatClick("1R")
                                                        }

                                                        SeatButton {
                                                            x: 265
                                                            y: 398
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "2R"
                                                            isBooked: seatSelectionView.isSeatBooked("2R")
                                                            isSelected: seatSelectionView.selectedSeatId === "2R"
                                                            onClicked: seatSelectionView.handleSeatClick("2R")
                                                        }

                                                        SeatButton {
                                                            id: seat3R
                                                            x: 265
                                                            y: 481
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "3R"
                                                            isBooked: seatSelectionView.isSeatBooked("3R")
                                                            isSelected: seatSelectionView.selectedSeatId === "3R"
                                                            onClicked: seatSelectionView.handleSeatClick("3R")
                                                        }

                                                        SeatButton {
                                                            id: seat4R
                                                            x: 265
                                                            y: 519
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "4R"
                                                            isBooked: seatSelectionView.isSeatBooked("4R")
                                                            isSelected: seatSelectionView.selectedSeatId === "4R"
                                                            onClicked: seatSelectionView.handleSeatClick("4R")
                                                        }

                                                        // Front section - Column 3 (S seats)
                                                        SeatButton {
                                                            id: seat1S
                                                            x: 215
                                                            y: 360
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "1S"
                                                            isBooked: seatSelectionView.isSeatBooked("1S")
                                                            isSelected: seatSelectionView.selectedSeatId === "1S"
                                                            onClicked: seatSelectionView.handleSeatClick("1S")
                                                        }

                                                        SeatButton {
                                                            id: seat2S
                                                            x: 215
                                                            y: 398
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "2S"
                                                            isBooked: seatSelectionView.isSeatBooked("2S")
                                                            isSelected: seatSelectionView.selectedSeatId === "2S"
                                                            onClicked: seatSelectionView.handleSeatClick("2S")
                                                        }

                                                        SeatButton {
                                                            id: seat3S
                                                            x: 215
                                                            y: 481
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "3S"
                                                            isBooked: seatSelectionView.isSeatBooked("3S")
                                                            isSelected: seatSelectionView.selectedSeatId === "3S"
                                                            onClicked: seatSelectionView.handleSeatClick("3S")
                                                        }

                                                        SeatButton {
                                                            id: seat4S
                                                            x: 215
                                                            y: 519
                                                            width: 40
                                                            height: 32
                                                            seatNumber: "4S"
                                                            isBooked: seatSelectionView.isSeatBooked("4S")
                                                            isSelected: seatSelectionView.selectedSeatId === "4S"
                                                            onClicked: seatSelectionView.handleSeatClick("4S")
                                                        }

                                                        // Far right single column seats (T seats)
                                                        SeatButton {
                                                            id: seat1T
                                                            x: 1117
                                                            y: 366
                                                            seatNumber: "1T"
                                                            isBooked: seatSelectionView.isSeatBooked("1T")
                                                            isSelected: seatSelectionView.selectedSeatId === "1T"
                                                            onClicked: seatSelectionView.handleSeatClick("1T")
                                                        }

                                                        SeatButton {
                                                            id: seat2T
                                                            x: 1117
                                                            y: 405
                                                            seatNumber: "2T"
                                                            isBooked: seatSelectionView.isSeatBooked("2T")
                                                            isSelected: seatSelectionView.selectedSeatId === "2T"
                                                            onClicked: seatSelectionView.handleSeatClick("2T")
                                                        }

                                                        SeatButton {
                                                            id: seat3T
                                                            x: 1117
                                                            y: 477
                                                            seatNumber: "3T"
                                                            isBooked: seatSelectionView.isSeatBooked("3T")
                                                            isSelected: seatSelectionView.selectedSeatId === "3T"
                                                            onClicked: seatSelectionView.handleSeatClick("3T")
                                                        }

                                                        SeatButton {
                                                            id: seat4T
                                                            x: 1117
                                                            y: 516
                                                            seatNumber: "4T"
                                                            isBooked: seatSelectionView.isSeatBooked("4T")
                                                            isSelected: seatSelectionView.selectedSeatId === "4T"
                                                            onClicked: seatSelectionView.handleSeatClick("4T")
                                                        }
                                                    }
                                                }
                                            }

                                            // Booking confirmation
                                            Rectangle {
                                                width: 700
                                                height: 220
                                                color: "#161b22"
                                                radius: 12
                                                border.color: "#30363d"
                                                border.width: 1
                                                visible: seatSelectionView.selectedSeatId !== ""
                                                anchors.horizontalCenter: parent.horizontalCenter

                                                Timer {
                                                    id: returnTimer
                                                    interval: 2000
                                                    repeat: false
                                                    onTriggered: {
                                                        currentView = "flights"
                                                        seatSelectionView.selectedSeatId = ""
                                                        passengerNameInput.text = ""
                                                        bookingStatusText.visible = false
                                                    }
                                                }

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
                                                                seatSelectionView.selectedSeatId,
                                                                currentUsername
                                                            )

                                                            if (bookingId === "ALREADY_BOOKED") {
                                                                bookingStatusText.text = "✗ You already have a booking on this flight!"
                                                                bookingStatusText.color = "#f85149"
                                                                bookingStatusText.visible = true
                                                            } else if (bookingId !== "") {
                                                                console.log("Booking confirmed! ID:", bookingId)
                                                                console.log("Flight:", selectedFlight.flightNumber)
                                                                console.log("Seat:", seatSelectionView.selectedSeatId)
                                                                console.log("Passenger:", passengerNameInput.text)

                                                                // Refresh booked seats to include the newly booked seat
                                                                seatSelectionView.bookedSeats = flightHandler.getBookedSeats(selectedFlight.flightNumber)
                                                                flightsList = flightHandler.getAllFlights()

                                                                bookingStatusText.text = "✓ Booking confirmed! ID: " + bookingId
                                                                bookingStatusText.color = "#3fb950"
                                                                bookingStatusText.visible = true

                                                                // Return to flights after a short delay
                                                                returnTimer.start()
                                                            } else {
                                                                bookingStatusText.text = "✗ Booking failed - seat may already be booked"
                                                                bookingStatusText.color = "#f85149"
                                                                bookingStatusText.visible = true
                                                            }
                                                        }
                                                    }

                                                    Text {
                                                        id: bookingStatusText
                                                        text: ""
                                                        color: "#3fb950"
                                                        font.pixelSize: 14
                                                        font.bold: true
                                                        width: 400
                                                        wrapMode: Text.WordWrap
                                                        horizontalAlignment: Text.AlignHCenter
                                                        anchors.horizontalCenter: parent.horizontalCenter
                                                        visible: false
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
