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
		# this is not platform dependent, the cursed name "Debug-iphoneos" is only necessary to make qmlimportscanner skip this directory for performance reasons: https://code.qt.io/cgit/qt/qtdeclarative.git/tree/tools/qmlimportscanner/main.cpp?h=v6.6.1#n742
		set(ICON_FILE "${CMAKE_BINARY_DIR}/icons-Debug-iphoneos/${ICON}.svg")

		if (NOT EXISTS "${ICON_FILE}")
			get_filename_component(ICON_DIR "${ICON_FILE}" DIRECTORY)
			file(MAKE_DIRECTORY "${ICON_DIR}")
			file(COPY_FILE "${quartz_icons_SOURCE_DIR}/src/${ICON}/materialicons/24px.svg" "${ICON_FILE}" ONLY_IF_DIFFERENT)
		endif()

		list(APPEND QUARTZ_ICONS_LIST "${ICON_FILE}")
		set_source_files_properties("${ICON_FILE}" PROPERTIES QT_RESOURCE_ALIAS "${ICON}")
	endforeach()
	# remove the bloated icons repository now, so that qmlimportscanner does not need to traverse it
	file(REMOVE_RECURSE "${quartz_icons_SOURCE_DIR}")

	qt_add_resources("${target}" QUARTZ_ICONS FILES ${QUARTZ_ICONS_LIST})
endfunction()

# install
install(TARGETS "${PROJECT_NAME}")
