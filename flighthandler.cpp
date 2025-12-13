#include "flighthandler.h"
#include <qdatetime.h>

FlightHandler::FlightHandler(AirlineSystem* system, QObject *parent)
    : QObject(parent), airlineSystem(system)
{
    // Initialize with some pre-booked seats for demo
    bookedSeatsMap["F102"] = QStringList() << "1A" << "1B" << "2C" << "3D";
}

QVariantMap FlightHandler::flightToVariantMap(const Flight* flight)
{
    QVariantMap map;
    if (flight) {
        map["flightNumber"] = QString::fromStdString(flight->getFlightNumber());
        map["origin"] = QString::fromStdString(flight->getOrigin());
        map["destination"] = QString::fromStdString(flight->getDestination());
        map["time"] = QString::fromStdString(flight->getTime());

        int available = 0;
        int total = 106;
        for (int i = 1; i <= total; i++) {
            if (flight->isSeatAvailable(i)) {
                available++;
            }
        }
        map["availableSeats"] = available;
        map["totalSeats"] = total;
    }
    return map;
}

QString FlightHandler::seatIdToNumber(const QString &seatId)
{
    return seatId;
}

QVariantList FlightHandler::getAllFlights()
{
    QVariantList flightList;

    // Flight F101
    QVariantMap f1;
    f1["flightNumber"] = "F101";
    f1["origin"] = "New York";
    f1["destination"] = "London";
    f1["time"] = "08:00";
    f1["totalSeats"] = 106;
    // Calculate available seats
    int bookedF101 = bookedSeatsMap.contains("F101") ? bookedSeatsMap["F101"].length() : 0;
    f1["availableSeats"] = 106 - bookedF101;
    flightList.append(f1);

    // Flight F102
    QVariantMap f2;
    f2["flightNumber"] = "F102";
    f2["origin"] = "London";
    f2["destination"] = "Paris";
    f2["time"] = "10:30";
    f2["totalSeats"] = 106;
    int bookedF102 = bookedSeatsMap.contains("F102") ? bookedSeatsMap["F102"].length() : 0;
    f2["availableSeats"] = 106 - bookedF102;
    flightList.append(f2);

    // Flight F201
    QVariantMap f3;
    f3["flightNumber"] = "F201";
    f3["origin"] = "Tokyo";
    f3["destination"] = "Seoul";
    f3["time"] = "12:15";
    f3["totalSeats"] = 106;
    int bookedF201 = bookedSeatsMap.contains("F201") ? bookedSeatsMap["F201"].length() : 0;
    f3["availableSeats"] = 106 - bookedF201;
    flightList.append(f3);

    // Flight F202
    QVariantMap f4;
    f4["flightNumber"] = "F202";
    f4["origin"] = "Delhi";
    f4["destination"] = "Mumbai";
    f4["time"] = "14:45";
    f4["totalSeats"] = 106;
    int bookedF202 = bookedSeatsMap.contains("F202") ? bookedSeatsMap["F202"].length() : 0;
    f4["availableSeats"] = 106 - bookedF202;
    flightList.append(f4);

    // Flight F301
    QVariantMap f5;
    f5["flightNumber"] = "F301";
    f5["origin"] = "Dubai";
    f5["destination"] = "Singapore";
    f5["time"] = "16:20";
    f5["totalSeats"] = 106;
    int bookedF301 = bookedSeatsMap.contains("F301") ? bookedSeatsMap["F301"].length() : 0;
    f5["availableSeats"] = 106 - bookedF301;
    flightList.append(f5);

    return flightList;
}

QVariantList FlightHandler::searchFlights(const QString &from, const QString &to)
{
    QVariantList allFlights = getAllFlights();
    QVariantList filtered;

    for (const QVariant &flight : allFlights) {
        QVariantMap flightMap = flight.toMap();
        QString origin = flightMap["origin"].toString();
        QString destination = flightMap["destination"].toString();

        if (origin.contains(from, Qt::CaseInsensitive) &&
            destination.contains(to, Qt::CaseInsensitive)) {
            filtered.append(flight);
        }
    }

    return filtered;
}

QVariantMap FlightHandler::getFlightDetails(const QString &flightNumber)
{
    QVariantList allFlights = getAllFlights();

    for (const QVariant &flight : allFlights) {
        QVariantMap flightMap = flight.toMap();
        if (flightMap["flightNumber"].toString() == flightNumber) {
            return flightMap;
        }
    }

    return QVariantMap();
}

QVariantList FlightHandler::getFlightSeats(const QString &flightNumber)
{
    QVariantList seats;

    for (int i = 1; i <= 106; i++) {
        QVariantMap seat;
        seat["number"] = i;
        seat["available"] = true;
        seats.append(seat);
    }

    return seats;
}

QVariantList FlightHandler::getBookedSeats(const QString &flightNumber)
{
    QVariantList bookedSeats;

    if (bookedSeatsMap.contains(flightNumber)) {
        QStringList seats = bookedSeatsMap[flightNumber];
        for (const QString &seatId : seats) {
            bookedSeats.append(seatId);
        }
    }

    return bookedSeats;
}

QString FlightHandler::bookFlight(const QString &flightNumber, const QString &passengerName, const QString &seatId, const QString &username)
{
    // Check if user already has a booking on this flight
    for (auto it = userBookingsMap.begin(); it != userBookingsMap.end(); ++it) {
        QVariantMap booking = it.value();
        if (booking["username"].toString() == username &&
            booking["flightNumber"].toString() == flightNumber) {
            qDebug() << "User already has a booking on this flight";
            return "ALREADY_BOOKED"; // Special return value
        }
    }

    // Check if seat is already booked
    if (bookedSeatsMap.contains(flightNumber)) {
        if (bookedSeatsMap[flightNumber].contains(seatId)) {
            return ""; // Seat already booked
        }
    }

    // Add the seat to the booked seats map
    bookedSeatsMap[flightNumber].append(seatId);

    // Generate booking ID
    QString bookingId = "BK" + QString::number(QDateTime::currentMSecsSinceEpoch());

    // Store booking details
    QVariantMap bookingDetails;
    bookingDetails["bookingId"] = bookingId;
    bookingDetails["username"] = username;
    bookingDetails["flightNumber"] = flightNumber;
    bookingDetails["seatId"] = seatId;
    bookingDetails["passengerName"] = passengerName;
    userBookingsMap[bookingId] = bookingDetails;

    return bookingId;
}

bool FlightHandler::cancelBooking(const QString &bookingId)
{
    if (!userBookingsMap.contains(bookingId)) {
        return false;
    }

    // Get booking details
    QVariantMap booking = userBookingsMap[bookingId];
    QString flightNumber = booking["flightNumber"].toString();
    QString seatId = booking["seatId"].toString();

    // Remove seat from booked seats
    if (bookedSeatsMap.contains(flightNumber)) {
        bookedSeatsMap[flightNumber].removeAll(seatId);
    }

    // Remove booking
    userBookingsMap.remove(bookingId);

    return true;
}

QVariantList FlightHandler::getMyBookings(const QString &username)
{
    QVariantList bookings;

    for (auto it = userBookingsMap.begin(); it != userBookingsMap.end(); ++it) {
        QVariantMap booking = it.value();
        if (booking["username"].toString() == username) {
            bookings.append(booking);
        }
    }

    return bookings;
}
