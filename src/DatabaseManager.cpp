#include "DatabaseManager.hpp"
#include "DateFormatter.hpp"

#include <QDebug>
#include <QDir>
#include <QSqlError>
#include <QStandardPaths>

QSqlQuery operator""_sql(const char* str, const size_t len)
{
    return QSqlQuery(QString::fromLatin1(str, len));
}

DatabaseManager::DatabaseManager(QObject* parent)
    : QObject(parent)
{
    const QDir dir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    if(!dir.exists())
        if(!dir.mkpath("."))
            qCritical() << "Failed to create directory: " << dir;

    const auto dbPath = dir.filePath("entries.db");
    const auto dbExists = QFile(dbPath).exists();

    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbPath);

    if(!db.open())
        qCritical() << "Failed to open database: " << db.databaseName();

    if(!dbExists)
        createTables();
}

DatabaseManager* DatabaseManager::instance(QQmlEngine*, QJSEngine*)
{
    // The simplest, but not the safest way possible
    // note: the pointer is managed by qt
    return new DatabaseManager;
}

void DatabaseManager::addEntry(const QString& emoji, const QString& note)
{
    auto query = "INSERT INTO entries (emoji, note, date) VALUES (?, ?, ?)"_sql;
    query.addBindValue(emoji);
    query.addBindValue(note);
    query.addBindValue(QDateTime::currentDateTime());

    if(!query.exec())
        qCritical() << "Failed to add entry: " << query.lastError();
}

QVariantList DatabaseManager::getEntries()
{
    QVariantList entries;

    auto query = "SELECT * FROM entries ORDER BY date DESC"_sql;
    while(query.next())
    {
        QVariantMap item;
        item["emoji"] = query.value(1).toString();
        item["note"] = query.value(2).toString();
        item["date"] = DateFormatter::format(query.value(3).toDateTime());

        entries.append(item);
    }

    return entries;
}

void DatabaseManager::createTables()
{
    if(!R"(CREATE TABLE IF NOT EXISTS entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            emoji TEXT,
            note TEXT,
            date DATETIME DEFAULT CURRENT_TIMESTAMP
        ))"_sql.exec())
        qCritical() << "Failed to create a table: entries";
}
