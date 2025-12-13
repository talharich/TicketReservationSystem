#ifndef FLIGHTHANDLER_H
#define FLIGHTHANDLER_H

#include <QObject>
#include <QString>
#include <QVariantList>
#include <QVariantMap>
#include <QMap>
#include <QStringList>
#include "SimpleAirline.h"

class FlightHandler : public QObject
{
    Q_OBJECT
public:
    explicit FlightHandler(AirlineSystem* system, QObject *parent = nullptr);

    Q_INVOKABLE QVariantList getAllFlights();
    Q_INVOKABLE QVariantList searchFlights(const QString &from, const QString &to);
    Q_INVOKABLE QVariantMap getFlightDetails(const QString &flightNumber);
    Q_INVOKABLE QVariantList getFlightSeats(const QString &flightNumber);
    Q_INVOKABLE QVariantList getBookedSeats(const QString &flightNumber);
    Q_INVOKABLE QString bookFlight(const QString &flightNumber, const QString &passengerName, const QString &seatId, const QString &username);
    Q_INVOKABLE bool cancelBooking(const QString &bookingId);
    Q_INVOKABLE QVariantList getMyBookings(const QString &username);

private:
    AirlineSystem* airlineSystem;
    QVariantMap flightToVariantMap(const Flight* flight);
    QString seatIdToNumber(const QString &seatId);

    // Store booked seats: flightNumber -> list of seatIds
    QMap<QString, QStringList> bookedSeatsMap;

    // Store user bookings: bookingId -> {username, flightNumber, seatId, passengerName}
    QMap<QString, QVariantMap> userBookingsMap;
};

#endif // FLIGHTHANDLER_H
