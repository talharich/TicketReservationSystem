#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "loginhandler.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    LoginHandler loginHandler;
    engine.rootContext()->setContextProperty("loginHandler", &loginHandler);

    // Try to load from module first
    engine.loadFromModule("TicketResevationSystem2", "Main");

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
