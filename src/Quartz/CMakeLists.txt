list(APPEND QUARTZ_QT_MODULES Core Qml Quick QuickControls2)
find_package(Qt6 6.6 COMPONENTS ${QUARTZ_QT_MODULES} REQUIRED)
qt_standard_project_setup()
list(TRANSFORM QUARTZ_QT_MODULES PREPEND "Qt6::")
qt_policy(SET QTP0001 NEW)

add_compile_definitions(QUARTZ_VERSION="${PROJECT_VERSION}")

file(GLOB_RECURSE SRCS "./*.cpp")
file(GLOB_RECURSE HDRS "./*.hpp")
file(GLOB_RECURSE QMLS RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "qml/*.qml")

qt_add_library("${PROJECT_NAME}" STATIC)

target_include_directories("${PROJECT_NAME}" PUBLIC ".")
target_link_libraries("${PROJECT_NAME}" PRIVATE ${QUARTZ_QT_MODULES})

qt_add_qml_module("${PROJECT_NAME}" URI "Quartz" VERSION "${PROJECT_VERSION}" QML_FILES ${QMLS} SOURCES ${SRCS} ${HDRS})
set_target_properties("${PROJECT_NAME}" PROPERTIES QT_QMLCACHEGEN_ARGUMENTS "--only-bytecode")

# material design icons
function(quartz_bundle_icons target)
	include(FetchContent)
	FetchContent_Declare(quartz_icons URL https://github.com/google/material-design-icons/archive/refs/tags/4.0.0.tar.gz URL_HASH SHA256=b1b068d625d5e15d6ec0059209cec67bc4c46e39c4611b859d6f6680dbf23934)
	FetchContent_MakeAvailable(quartz_icons)

	# relative paths are required for QRC
	cmake_path(RELATIVE_PATH quartz_icons_SOURCE_DIR)

	foreach(ICON IN LISTS ARGN)
		list(APPEND QUARTZ_ICONS_LIST "${quartz_icons_SOURCE_DIR}/src/${ICON}/materialicons/24px.svg")
		set_source_files_properties("${quartz_icons_SOURCE_DIR}/src/${ICON}/materialicons/24px.svg" PROPERTIES QT_RESOURCE_ALIAS "${ICON}")
	endforeach()
	qt_add_resources("${target}" QUARTZ_ICONS FILES ${QUARTZ_ICONS_LIST})
endfunction()

# install
install(TARGETS "${PROJECT_NAME}")
