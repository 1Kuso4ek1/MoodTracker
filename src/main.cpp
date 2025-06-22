#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "DatabaseManager.hpp"

int main(int argc, char *argv[])
{
    const QGuiApplication app(argc, argv);

    qmlRegisterSingletonType<DatabaseManager>("DatabaseManager", 1, 0, "DatabaseManager", DatabaseManager::instance);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("QmlApp", "Main");

    return app.exec();
}
