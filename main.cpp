#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "loginhandler.h"
#include "flighthandler.h"
#include "SimpleAirline.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Create shared airline system
    AirlineSystem* airlineSystem = new AirlineSystem();

    // Create handlers
    LoginHandler* loginHandler = new LoginHandler(airlineSystem);
    FlightHandler* flightHandler = new FlightHandler(airlineSystem);

    // Register with QML
    engine.rootContext()->setContextProperty("loginHandler", loginHandler);
    engine.rootContext()->setContextProperty("flightHandler", flightHandler);

    // Try to load from module first
    engine.loadFromModule("TicketResevationSystem2", "Main");

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
