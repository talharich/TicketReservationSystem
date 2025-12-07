#ifndef SIMPLEAIRLINE_H
#define SIMPLEAIRLINE_H

#include <iostream>
#include <string>
#include <vector>

using namespace std;

class User {
private:
    string username;
    string password;
public:
    User(string uname, string pwd);
    bool checkLogin(string uname, string pwd) const;
    string getUsername() const;
};

class Flight {
private:
    string flightNumber;
    string origin;
    string destination;
    string time;
    int totalSeats;
    vector<bool> seats;
public:
    Flight(string num, string orig, string dest, string t, int seats);
    string getFlightNumber() const;
    string getOrigin() const;
    string getDestination() const;
    string getTime() const;
    void showSeats() const;
    bool bookSeat(int seatNum);
    bool cancelSeat(int seatNum);
    bool isSeatAvailable(int seatNum) const;
    void showInfo() const;
};

class Booking {
private:
    string bookingId;
    string flightNumber;
    string passengerName;
    int seatNumber;
public:
    Booking(string id, string flight, string name, int seat);
    string getBookingId() const;
    string getFlightNumber() const;
    string getPassengerName() const;
    int getSeatNumber() const;
    void showInfo() const;
};

class AirlineSystem {
private:
    vector<User> users;
    vector<Flight> flights;
    vector<Booking> bookings;
    bool loggedIn;
    string currentUser;

    string createBookingId();
    Flight* findFlight(string flightNumber);
    Booking* findBooking(string bookingId);
    void setupData();

public:
    AirlineSystem();
    bool login(string username, string password);
    void logout();
    bool isLoggedIn() const;
    void showAllFlights();
    void searchFlights(string from, string to);
    void showFlightSeats(string flightNumber);
    string bookTicket(string flightNumber, string passengerName, int seatNumber);
    bool cancelTicket(string bookingId);
    void showBooking(string bookingId);
};

#endif
