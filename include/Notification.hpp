#pragma once
#include <QObject>
#include <QVariantMap>

class Notification : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString appName MEMBER appName NOTIFY appNameChanged)
    Q_PROPERTY(uint replacesId MEMBER replacesId NOTIFY replacesIdChanged)
    Q_PROPERTY(QString icon MEMBER icon NOTIFY iconChanged)
    Q_PROPERTY(QString title MEMBER title NOTIFY titleChanged)
    Q_PROPERTY(QString message MEMBER message NOTIFY messageChanged)
    Q_PROPERTY(QStringList actions MEMBER actions NOTIFY actionsChanged)
    Q_PROPERTY(QVariantMap hints MEMBER hints NOTIFY hintsChanged)
    Q_PROPERTY(int timeout MEMBER timeout NOTIFY timeoutChanged)
public:
    explicit Notification(QObject* parent = nullptr) : QObject(parent) {};

    Q_INVOKABLE void send() const;

signals:
    void appNameChanged();
    void replacesIdChanged();
    void iconChanged();
    void titleChanged();
    void messageChanged();
    void actionsChanged();
    void hintsChanged();
    void timeoutChanged();

private:
    QString appName;
    uint replacesId = 0;
    QString icon;
    QString title;
    QString message;
    QStringList actions;
    QVariantMap hints;
    int timeout = 3000;
};
