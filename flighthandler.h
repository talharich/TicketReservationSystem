#ifndef FLIGHTHANDLER_H
#define FLIGHTHANDLER_H

#include <QObject>
#include <QString>
#include <QVariantList>
#include <QVariantMap>
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
    Q_INVOKABLE QString bookFlight(const QString &flightNumber, const QString &passengerName, int seatNumber);
    Q_INVOKABLE bool cancelBooking(const QString &bookingId);
    Q_INVOKABLE QVariantList getMyBookings();

private:
    AirlineSystem* airlineSystem;
    QVariantMap flightToVariantMap(const Flight* flight);
};

#endif // FLIGHTHANDLER_H
