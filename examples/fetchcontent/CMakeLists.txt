cmake_minimum_required(VERSION 4.0)
project(fetchcontent VERSION 1.0)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

list(APPEND QT_MODULES Core Qml Quick QuickControls2)
find_package(Qt6 6.9 COMPONENTS ${QT_MODULES} REQUIRED)
qt_standard_project_setup(REQUIRES ${Qt6_VERSION})
list(TRANSFORM QT_MODULES PREPEND "Qt6::")

include_directories("src")

file(GLOB_RECURSE SRCS "src/*.cpp")
file(GLOB_RECURSE QMLS RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "src/qml/*.qml")

qt_add_executable("${PROJECT_NAME}" ${SRCS})

qt_add_qml_module("${PROJECT_NAME}" URI "FetchContent" VERSION "${PROJECT_VERSION}" QML_FILES ${QMLS})
set_target_properties("${PROJECT_NAME}" PROPERTIES QT_QMLCACHEGEN_ARGUMENTS "--only-bytecode")

include(FetchContent)
FetchContent_Declare(quartz GIT_REPOSITORY https://github.com/vimpostor/quartz.git GIT_TAG origin/master)
FetchContent_MakeAvailable(quartz)

target_link_libraries("${PROJECT_NAME}" PRIVATE ${QT_MODULES})
quartz_link("${PROJECT_NAME}")
