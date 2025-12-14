cmake_minimum_required(VERSION 3.16)

project(TicketResevationSystem2 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(appTicketResevationSystem2
    main.cpp
    SimpleAirline.h
    SimpleAirline.cpp
    loginhandler.h
    loginhandler.cpp
    flighthandler.h
    flighthandler.cpp
)

qt_add_qml_module(appTicketResevationSystem2
    URI TicketResevationSystem2
    VERSION 1.0
    QML_FILES
        Main.qml
        SeatSelection.qml
        SeatButton.qml
    SOURCES loginhandler.h
)

# Add images as separate resource
set(IMAGE_FILES
    images/loginbg3.jpg
    images/login-bg1.jpg
    images/login-bg2.jpg
    "images/Airplane seating chart.png"
)

qt_add_resources(appTicketResevationSystem2 "images"
    PREFIX "/images"
    BASE "images"
    FILES ${IMAGE_FILES}
)

set_target_properties(appTicketResevationSystem2 PROPERTIES
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appTicketResevationSystem2
    PRIVATE Qt6::Quick
)
