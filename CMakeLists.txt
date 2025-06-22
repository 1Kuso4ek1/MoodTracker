cmake_minimum_required(VERSION 3.16)

project(QmlApp VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Core Sql)

qt_standard_project_setup(REQUIRES 6.9)

qt_add_executable(appQmlApp
    src/main.cpp
        src/DatabaseManager.cpp
        include/DatabaseManager.hpp
        src/DateFormatter.cpp
        include/DateFormatter.hpp
)

target_include_directories(appQmlApp PRIVATE include)

set_source_files_properties(qml/Navigation.qml
    PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(appQmlApp
    URI QmlApp
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        QML_FILES qml/HomePage.qml qml/BlurredBackground.qml qml/NewEntry.qml qml/Navigation.qml
        RESOURCES resources.qrc
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appQmlApp PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appQmlApp
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appQmlApp
    PRIVATE Qt6::Quick Qt6::Sql
)

include(GNUInstallDirs)
install(TARGETS appQmlApp
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
