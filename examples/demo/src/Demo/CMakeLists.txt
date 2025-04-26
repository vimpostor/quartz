list(APPEND QT_MODULES Core Qml Quick QuickControls2)
find_package(Qt6 6.9 COMPONENTS ${QT_MODULES} REQUIRED)
qt_standard_project_setup(REQUIRES 6.9)
list(TRANSFORM QT_MODULES PREPEND "Qt6::")

file(GLOB_RECURSE SRCS "*.cpp")
file(GLOB_RECURSE QMLS RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "*.qml")

qt_add_executable("${PROJECT_NAME}" ${SRCS})

qt_add_qml_module("${PROJECT_NAME}" URI "Demo" VERSION "${PROJECT_VERSION}" QML_FILES ${QMLS})
set_target_properties("${PROJECT_NAME}" PROPERTIES QT_QMLCACHEGEN_ARGUMENTS "--only-bytecode")

target_link_libraries("${PROJECT_NAME}" PRIVATE ${QT_MODULES})
quartz_link("${PROJECT_NAME}")
