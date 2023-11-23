cmake_minimum_required(VERSION 3.27)
project(fetchcontent VERSION 1.0)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

list(APPEND QT_MODULES Core Qml Quick QuickControls2)
find_package(Qt6 6.6 COMPONENTS ${QT_MODULES} REQUIRED)
qt_standard_project_setup()
list(TRANSFORM QT_MODULES PREPEND "Qt6::")

include_directories("src")

file(GLOB_RECURSE SRCS "src/*.cpp")
file(GLOB_RECURSE QMLS RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "src/qml/*.qml")

qt_add_executable("${PROJECT_NAME}" ${SRCS})

qt_add_qml_module(${PROJECT_NAME} URI "FetchContent" VERSION "${PROJECT_VERSION}" NO_RESOURCE_TARGET_PATH QML_FILES ${QMLS})
set_target_properties(${PROJECT_NAME} PROPERTIES QT_QMLCACHEGEN_ARGUMENTS "--only-bytecode")

include(FetchContent)
# For your own projects please use GIT_TAG with a proper static git commit hash or git tag
# We only use origin/master here, because this demo is actively kept in sync with the latest changes
# Using origin/master is bad for reproducability and WILL cause breaking changes without you noticing
FetchContent_Declare(quartz GIT_REPOSITORY https://github.com/vimpostor/quartz.git GIT_TAG origin/master)
FetchContent_MakeAvailable(quartz)

target_link_libraries(${PROJECT_NAME} PRIVATE ${QT_MODULES} quartz quartzplugin)