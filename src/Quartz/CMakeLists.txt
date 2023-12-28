list(APPEND QUARTZ_QT_MODULES Core Qml Quick QuickControls2)
find_package(Qt6 6.6 COMPONENTS ${QUARTZ_QT_MODULES} REQUIRED)
qt_standard_project_setup()
list(TRANSFORM QUARTZ_QT_MODULES PREPEND "Qt6::")
qt_policy(SET QTP0001 NEW)

add_compile_definitions(QUARTZ_VERSION="${PROJECT_VERSION}")

file(GLOB_RECURSE SRCS "./*.cpp")
file(GLOB_RECURSE HDRS "./*.hpp")
file(GLOB_RECURSE QMLS RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "qml/*.qml")

set_source_files_properties(qml/Icons.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_library("${PROJECT_NAME}" STATIC)

target_include_directories("${PROJECT_NAME}" PUBLIC ".")
target_include_directories("${PROJECT_NAME}" PUBLIC "quartz")
target_link_libraries("${PROJECT_NAME}" PRIVATE ${QUARTZ_QT_MODULES})

qt_add_qml_module("${PROJECT_NAME}" URI "Quartz" VERSION "${PROJECT_VERSION}" QML_FILES ${QMLS} SOURCES ${SRCS} ${HDRS})
set_target_properties("${PROJECT_NAME}" PROPERTIES QT_QMLCACHEGEN_ARGUMENTS "--only-bytecode")

# Bundle material design icons
function(quartz_bundle_icons target style)
	include(FetchContent)

	set(QUARTZ_ICONS_ARCHIVE "https://github.com/google/material-design-icons/raw/70c7b5e1f68f9f92e4baf5d34b4b4a9ba590f4e9/variablefont")
	set(QUARTZ_ICONS_NAME "MaterialSymbols${style}%5BFILL,GRAD,opsz,wght%5D")

	set(QUARTZ_ICONS_HASH "7ef095754a4b53c9dce8a118033700ed023bcf93bf8ce534c397e3a158fbef14") # Outlined
	if (style EQUAL "Rounded")
		set(QUARTZ_ICONS_HASH "03b92c9792515abb32988d6437c30a9224f954c8beb8fd2f75e6b6fb6d448e87")
	elseif (style EQUAL "Sharp")
		set(QUARTZ_ICONS_HASH "ed0c22ae86103c81c5fd11f92f47245ded0818d2755bc6d979bf4b72d20e1c49")
	endif()
	FetchContent_Declare(quartz_icons URL "${QUARTZ_ICONS_ARCHIVE}/${QUARTZ_ICONS_NAME}.woff2" URL_HASH "SHA256=${QUARTZ_ICONS_HASH}" DOWNLOAD_NO_EXTRACT ON)
	FetchContent_MakeAvailable(quartz_icons)

	FetchContent_Declare(quartz_codepoints URL "${QUARTZ_ICONS_ARCHIVE}/${QUARTZ_ICONS_NAME}.codepoints" URL_HASH "SHA256=d896f7cf2d4da45e7cffd7cc00bb1985b119d198188cb72a97ec6f8bd241d4ab" DOWNLOAD_NO_EXTRACT ON)
	FetchContent_MakeAvailable(quartz_codepoints)

	# relative paths are required for QRC
	cmake_path(RELATIVE_PATH quartz_icons_SOURCE_DIR)
	set_source_files_properties("${quartz_icons_SOURCE_DIR}/${QUARTZ_ICONS_NAME}.woff2" PROPERTIES QT_RESOURCE_ALIAS "MaterialSymbols.woff2")
	cmake_path(RELATIVE_PATH quartz_codepoints_SOURCE_DIR)
	set_source_files_properties("${quartz_codepoints_SOURCE_DIR}/${QUARTZ_ICONS_NAME}.codepoints" PROPERTIES QT_RESOURCE_ALIAS "MaterialSymbols.codepoints")

	qt_add_resources("${target}" quartz_icons FILES "${quartz_icons_SOURCE_DIR}/${QUARTZ_ICONS_NAME}.woff2" "${quartz_codepoints_SOURCE_DIR}/${QUARTZ_ICONS_NAME}.codepoints")
endfunction()

function(quartz_link target)
	cmake_parse_arguments(QUARTZ_LINK "NO_ICONS" "ICON_STYLE" "" ${ARGN})

	target_link_libraries("${target}" PRIVATE quartz quartzplugin)

	if (NOT QUARTZ_LINK_ICON_STYLE)
		set(QUARTZ_LINK_ICON_STYLE "Outlined") # possible values: Outlined, Rounded, Sharp
	endif()

	if (NOT QUARTZ_LINK_NO_ICONS)
		quartz_bundle_icons("${target}" "${QUARTZ_LINK_ICON_STYLE}")
	endif()
endfunction()

# install is currently broken, because QML modules cannot be installed systemwide in the filesystem
# As a workaround, all projects should include this project with FetchContent, which builds it and statically links against it.
# When QML modules get install support, we can uncomment this and start porting projects from FetchContent to native install.
# Until then, the following line should stay commented as it would cause FetchContent projects to install libquartz systemwide, which clashes once we want to install more than one Quartz project on the system.
# install(TARGETS "${PROJECT_NAME}")
