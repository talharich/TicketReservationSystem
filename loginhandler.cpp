#include "loginhandler.h"
#include <iostream>
#include <sstream>

LoginHandler::LoginHandler(QObject *parent)
    : QObject(parent)
{
    airlineSystem = new AirlineSystem();
}

QString LoginHandler::attemptLogin(const QString &username, const QString &password)
{
    std::stringstream buffer;
    std::streambuf* old = std::cout.rdbuf(buffer.rdbuf());

    bool success = airlineSystem->login(username.toStdString(), password.toStdString());

    std::cout.rdbuf(old);

    if (success) {
        return "✓ Login successful! Welcome " + username;
    } else {
        return "✗ Login failed! Wrong username or password.";
    }
}

bool LoginHandler::isUserLoggedIn() const
{
    return airlineSystem->isLoggedIn();
}
