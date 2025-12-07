#ifndef LOGINHANDLER_H
#define LOGINHANDLER_H

#include <QObject>
#include <QString>
#include "SimpleAirline.h"

class LoginHandler : public QObject
{
    Q_OBJECT
public:
    explicit LoginHandler(QObject *parent = nullptr);

    Q_INVOKABLE QString attemptLogin(const QString &username, const QString &password);
    Q_INVOKABLE bool isUserLoggedIn() const;

private:
    AirlineSystem* airlineSystem;
};

#endif // LOGINHANDLER_H
