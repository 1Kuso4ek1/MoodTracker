#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "DatabaseManager.hpp"
#include "Notification.hpp"

int main(int argc, char *argv[])
{
    const QGuiApplication app(argc, argv);

    qmlRegisterSingletonType<DatabaseManager>("DatabaseManager", 1, 0, "DatabaseManager", DatabaseManager::instance);
    qmlRegisterType<Notification>("Notification", 1, 0, "Notification");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        [] { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("MoodTrackerApp", "Main");

    return app.exec();
}
