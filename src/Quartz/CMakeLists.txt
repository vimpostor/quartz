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
target_include_directories("${PROJECT_NAME}" PUBLIC "quartz")
target_link_libraries("${PROJECT_NAME}" PRIVATE ${QUARTZ_QT_MODULES})

qt_add_qml_module("${PROJECT_NAME}" URI "Quartz" VERSION "${PROJECT_VERSION}" QML_FILES ${QMLS} SOURCES ${SRCS} ${HDRS})
set_target_properties("${PROJECT_NAME}" PROPERTIES QT_QMLCACHEGEN_ARGUMENTS "--only-bytecode")

# Bundle material design icons:
# Optionally a list of icons can be passed after the target name. Otherwise all icons are bundled.
function(quartz_bundle_icons target)
	include(FetchContent)
	FetchContent_Declare(quartz_icons URL https://github.com/marella/material-symbols/archive/refs/tags/v0.14.1.tar.gz URL_HASH SHA256=e41d1e52939c7cf1af87fde1ea33d10994aaaa2eb2b93a8a568c9ef24d8bb3c2)
	FetchContent_MakeAvailable(quartz_icons)

	# relative paths are required for QRC
	cmake_path(RELATIVE_PATH quartz_icons_SOURCE_DIR)

	if (NOT ARGN)
		# bundle all icons
		file(GLOB_RECURSE ARGN "${quartz_icons_SOURCE_DIR}/svg/500/outlined/*.svg")
		list(TRANSFORM ARGN REPLACE "^.*/svg/500/outlined/(.*).svg$" "\\1")

		if (NOT ARGN)
			# icons already moved
			file(GLOB_RECURSE ARGN "${CMAKE_BINARY_DIR}/icons-Debug-iphoneos/*.svg")
			list(TRANSFORM ARGN REPLACE "^.*/icons-Debug-iphoneos/(.*)\.svg$" "\\1")
		endif()
	endif()

	set(QUARTZ_ICONS_LIST "")
	foreach(ICON IN LISTS ARGN)
		# the cursed name "Debug-iphoneos" is only necessary to make qmlimportscanner skip this directory for performance reasons: https://code.qt.io/cgit/qt/qtdeclarative.git/tree/tools/qmlimportscanner/main.cpp?h=v6.6.1#n742
		set(ICON_FILE "${CMAKE_BINARY_DIR}/icons-Debug-iphoneos/${ICON}.svg")

		if (NOT EXISTS "${ICON_FILE}")
			get_filename_component(ICON_DIR "${ICON_FILE}" DIRECTORY)
			file(MAKE_DIRECTORY "${ICON_DIR}")
			file(COPY_FILE "${quartz_icons_SOURCE_DIR}/svg/500/outlined/${ICON}.svg" "${ICON_FILE}" ONLY_IF_DIFFERENT)
		endif()

		list(APPEND QUARTZ_ICONS_LIST "${ICON_FILE}")
		set_source_files_properties("${ICON_FILE}" PROPERTIES QT_RESOURCE_ALIAS "${ICON}")
	endforeach()
	# remove the bloated icons repository now, so that qmlimportscanner does not try to traverse it
	file(REMOVE_RECURSE "${quartz_icons_SOURCE_DIR}")

	qt_add_resources("${target}" QUARTZ_ICONS PREFIX "/svg" FILES ${QUARTZ_ICONS_LIST})
endfunction()

function(quartz_link target)
	target_link_libraries("${target}" PRIVATE quartz quartzplugin)

	cmake_parse_arguments(QUARTZ_LINK "ALL_ICONS;INTERNAL_ICONS" "" "ICONS" ${ARGN})

	if (QUARTZ_LINK_ALL_ICONS)
		# bundle all icons
		quartz_bundle_icons("${target}")
	elseif (QUARTZ_LINK_ICONS OR QUARTZ_LINK_INTERNAL_ICONS)
		# not bundling all icons, manually append icons that are needed by Quartz itself
		list(APPEND QUARTZ_LINK_ICONS "close")
		list(REMOVE_DUPLICATES QUARTZ_LINK_ICONS)
		quartz_bundle_icons("${target}" ${QUARTZ_LINK_ICONS})
	endif()
endfunction()

# install
install(TARGETS "${PROJECT_NAME}")
