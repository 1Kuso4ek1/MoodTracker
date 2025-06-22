#pragma once
#include <QQmlEngine>
#include <QtQmlIntegration/QtQmlIntegration>
#include <QtSql/QSqlQuery>

class DatabaseManager : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT
public:
    explicit DatabaseManager(QObject *parent = nullptr);

    Q_INVOKABLE static void addEntry(const QString& emoji, const QString& note);
    Q_INVOKABLE static QVariantList getEntries();

    static DatabaseManager* instance(QQmlEngine* engine, QJSEngine* scriptEngine);

private:
    static void createTables();

private:
    QSqlDatabase db;
};
