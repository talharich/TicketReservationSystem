#include "flighthandler.h"

FlightHandler::FlightHandler(AirlineSystem* system, QObject *parent)
    : QObject(parent), airlineSystem(system)
{
}

QVariantMap FlightHandler::flightToVariantMap(const Flight* flight)
{
    QVariantMap map;
    if (flight) {
        map["flightNumber"] = QString::fromStdString(flight->getFlightNumber());
        map["origin"] = QString::fromStdString(flight->getOrigin());
        map["destination"] = QString::fromStdString(flight->getDestination());
        map["time"] = QString::fromStdString(flight->getTime());

        // Count available seats (we'll need to add a method to Flight class for this)
        int available = 0;
        int total = 10; // hardcoded for now, should come from Flight
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

QVariantList FlightHandler::getAllFlights()
{
    QVariantList flightList;

    // Get flights from the airline system
    // Since we don't have direct access to the flights vector, we'll need to add a getter
    // For now, we'll return the hardcoded flights

    QVariantMap f1;
    f1["flightNumber"] = "F101";
    f1["origin"] = "New York";
    f1["destination"] = "London";
    f1["time"] = "08:00";
    f1["availableSeats"] = 10;
    f1["totalSeats"] = 10;
    flightList.append(f1);

    QVariantMap f2;
    f2["flightNumber"] = "F102";
    f2["origin"] = "London";
    f2["destination"] = "Paris";
    f2["time"] = "10:30";
    f2["availableSeats"] = 10;
    f2["totalSeats"] = 10;
    flightList.append(f2);

    QVariantMap f3;
    f3["flightNumber"] = "F201";
    f3["origin"] = "Tokyo";
    f3["destination"] = "Seoul";
    f3["time"] = "12:15";
    f3["availableSeats"] = 10;
    f3["totalSeats"] = 10;
    flightList.append(f3);

    QVariantMap f4;
    f4["flightNumber"] = "F202";
    f4["origin"] = "Delhi";
    f4["destination"] = "Mumbai";
    f4["time"] = "14:45";
    f4["availableSeats"] = 10;
    f4["totalSeats"] = 10;
    flightList.append(f4);

    QVariantMap f5;
    f5["flightNumber"] = "F301";
    f5["origin"] = "Dubai";
    f5["destination"] = "Singapore";
    f5["time"] = "16:20";
    f5["availableSeats"] = 10;
    f5["totalSeats"] = 10;
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

    // For now, return 10 seats with availability
    for (int i = 1; i <= 10; i++) {
        QVariantMap seat;
        seat["number"] = i;
        seat["available"] = true; // Check actual availability from airlineSystem
        seats.append(seat);
    }

    return seats;
}

QString FlightHandler::bookFlight(const QString &flightNumber, const QString &passengerName, int seatNumber)
{
    std::string bookingId = airlineSystem->bookTicket(
        flightNumber.toStdString(),
        passengerName.toStdString(),
        seatNumber
        );

    return QString::fromStdString(bookingId);
}

bool FlightHandler::cancelBooking(const QString &bookingId)
{
    return airlineSystem->cancelTicket(bookingId.toStdString());
}

QVariantList FlightHandler::getMyBookings()
{
    QVariantList bookings;
    // TODO: Implement when we have access to bookings from AirlineSystem
    return bookings;
}
