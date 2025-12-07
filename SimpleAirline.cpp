#include "SimpleAirline.h"
#include <iostream>
#include <iomanip>

using namespace std;

// USER CLASS IMPLEMENTATION
User::User(string uname, string pwd)
    : username(uname), password(pwd) {}

bool User::checkLogin(string uname, string pwd) const {
    return (username == uname && password == pwd);
}

string User::getUsername() const {
    return username;
}

// FLIGHT CLASS IMPLEMENTATION
Flight::Flight(string num, string orig, string dest, string t, int total)
    : flightNumber(num), origin(orig), destination(dest), time(t), totalSeats(total) {
    seats.resize(total, false);
}

string Flight::getFlightNumber() const { return flightNumber; }
string Flight::getOrigin() const { return origin; }
string Flight::getDestination() const { return destination; }
string Flight::getTime() const { return time; }

void Flight::showSeats() const {
    cout << "\nSeats for Flight " << flightNumber << ":\n";
    cout << "------------------------\n";
    for (int i = 0; i < totalSeats; i++) {
        cout << "Seat " << (i + 1) << ": ";
        if (seats[i]) {
            cout << "[X] Booked\n";
        } else {
            cout << "[ ] Available\n";
        }
    }
}

bool Flight::bookSeat(int seatNum) {
    if (seatNum < 1 || seatNum > totalSeats) {
        cout << "Invalid seat number!\n";
        return false;
    }
    if (seats[seatNum - 1]) {
        cout << "Seat already booked!\n";
        return false;
    }
    seats[seatNum - 1] = true;
    cout << "Seat " << seatNum << " booked successfully!\n";
    return true;
}

bool Flight::cancelSeat(int seatNum) {
    if (seatNum < 1 || seatNum > totalSeats) {
        cout << "Invalid seat number!\n";
        return false;
    }
    if (!seats[seatNum - 1]) {
        cout << "Seat not booked!\n";
        return false;
    }
    seats[seatNum - 1] = false;
    cout << "Seat " << seatNum << " cancelled successfully!\n";
    return true;
}

bool Flight::isSeatAvailable(int seatNum) const {
    if (seatNum < 1 || seatNum > totalSeats) return false;
    return !seats[seatNum - 1];
}

void Flight::showInfo() const {
    int available = 0;
    for (bool seat : seats) {
        if (!seat) available++;
    }
    cout << flightNumber << " | " << origin << " to " << destination
         << " | " << time << " | Available: " << available << "/" << totalSeats << "\n";
}

// BOOKING CLASS IMPLEMENTATION
Booking::Booking(string id, string flight, string name, int seat)
    : bookingId(id), flightNumber(flight), passengerName(name), seatNumber(seat) {}

string Booking::getBookingId() const { return bookingId; }
string Booking::getFlightNumber() const { return flightNumber; }
string Booking::getPassengerName() const { return passengerName; }
int Booking::getSeatNumber() const { return seatNumber; }

void Booking::showInfo() const {
    cout << "\nBooking Details:\n";
    cout << "----------------\n";
    cout << "Booking ID: " << bookingId << "\n";
    cout << "Flight: " << flightNumber << "\n";
    cout << "Passenger: " << passengerName << "\n";
    cout << "Seat: " << seatNumber << "\n";
}

// AIRLINE SYSTEM CLASS IMPLEMENTATION
AirlineSystem::AirlineSystem() : loggedIn(false) {
    setupData();
}

void AirlineSystem::setupData() {
    users.push_back(User("admin", "admin123"));
    users.push_back(User("user1", "password1"));
    users.push_back(User("user2", "password2"));

    flights.push_back(Flight("F101", "New York", "London", "08:00", 10));
    flights.push_back(Flight("F102", "London", "Paris", "10:30", 10));
    flights.push_back(Flight("F201", "Tokyo", "Seoul", "12:15", 10));
    flights.push_back(Flight("F202", "Delhi", "Mumbai", "14:45", 10));
    flights.push_back(Flight("F301", "Dubai", "Singapore", "16:20", 10));
}

string AirlineSystem::createBookingId() {
    return "BK" + to_string(bookings.size() + 1001);
}

Flight* AirlineSystem::findFlight(string flightNumber) {
    for (auto& flight : flights) {
        if (flight.getFlightNumber() == flightNumber) {
            return &flight;
        }
    }
    return nullptr;
}

Booking* AirlineSystem::findBooking(string bookingId) {
    for (auto& booking : bookings) {
        if (booking.getBookingId() == bookingId) {
            return &booking;
        }
    }
    return nullptr;
}

bool AirlineSystem::login(string username, string password) {
    for (const auto& user : users) {
        if (user.checkLogin(username, password)) {
            loggedIn = true;
            currentUser = username;
            cout << "Login successful! Welcome " << username << "\n";
            return true;
        }
    }
    cout << "Login failed! Wrong username or password.\n";
    return false;
}

void AirlineSystem::logout() {
    loggedIn = false;
    currentUser = "";
    cout << "Logged out successfully!\n";
}

bool AirlineSystem::isLoggedIn() const {
    return loggedIn;
}

void AirlineSystem::showAllFlights() {
    cout << "\nAll Available Flights:\n";
    cout << "======================\n";
    for (const auto& flight : flights) {
        flight.showInfo();
    }
}

void AirlineSystem::searchFlights(string from, string to) {
    cout << "\nSearching flights from " << from << " to " << to << ":\n";
    cout << "===================================\n";
    bool found = false;
    for (const auto& flight : flights) {
        if (flight.getOrigin() == from && flight.getDestination() == to) {
            flight.showInfo();
            found = true;
        }
    }
    if (!found) {
        cout << "No flights found for this route.\n";
    }
}

void AirlineSystem::showFlightSeats(string flightNumber) {
    Flight* flight = findFlight(flightNumber);
    if (flight) {
        flight->showSeats();
    } else {
        cout << "Flight not found!\n";
    }
}

string AirlineSystem::bookTicket(string flightNumber, string passengerName, int seatNumber) {
    if (!loggedIn) {
        cout << "Please login first!\n";
        return "";
    }

    Flight* flight = findFlight(flightNumber);
    if (!flight) {
        cout << "Flight not found!\n";
        return "";
    }

    if (!flight->isSeatAvailable(seatNumber)) {
        cout << "Seat " << seatNumber << " is not available!\n";
        return "";
    }

    if (flight->bookSeat(seatNumber)) {
        string bookingId = createBookingId();
        bookings.push_back(Booking(bookingId, flightNumber, passengerName, seatNumber));
        cout << "Booking successful!\n";
        cout << "Your Booking ID: " << bookingId << "\n";
        return bookingId;
    }

    return "";
}

bool AirlineSystem::cancelTicket(string bookingId) {
    if (!loggedIn) {
        cout << "Please login first!\n";
        return false;
    }

    Booking* booking = findBooking(bookingId);
    if (!booking) {
        cout << "Booking not found!\n";
        return false;
    }

    Flight* flight = findFlight(booking->getFlightNumber());
    if (flight) {
        if (flight->cancelSeat(booking->getSeatNumber())) {
            for (auto it = bookings.begin(); it != bookings.end(); ++it) {
                if (it->getBookingId() == bookingId) {
                    bookings.erase(it);
                    cout << "Booking cancelled successfully!\n";
                    return true;
                }
            }
        }
    }

    cout << "Failed to cancel booking!\n";
    return false;
}

void AirlineSystem::showBooking(string bookingId) {
    Booking* booking = findBooking(bookingId);
    if (booking) {
        booking->showInfo();
    } else {
        cout << "Booking not found!\n";
    }
}
