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

	set(QUARTZ_ICONS_ARCHIVE "https://github.com/google/material-design-icons/raw/102f1f83c640eaadc335edef6901eb2b0e6fa557/variablefont")
	set(QUARTZ_ICONS_NAME "MaterialSymbols${style}%5BFILL,GRAD,opsz,wght%5D")

	set(QUARTZ_ICONS_HASH "6bec0324d927f32a0c9e94304249afa263deeeb2d6065255bee1fe6d7f51e9ea") # Outlined
	if (style EQUAL "Rounded")
		set(QUARTZ_ICONS_HASH "03b92c9792515abb32988d6437c30a9224f954c8beb8fd2f75e6b6fb6d448e87") # Rounded
	elseif (style EQUAL "Sharp")
		set(QUARTZ_ICONS_HASH "c3aa941fcfd7d5ab4d5ecf92d20de0dee16983bc9af5978c9970002880f3ea4b") # Sharp
	endif()
	FetchContent_Declare(quartz_icons URL "${QUARTZ_ICONS_ARCHIVE}/${QUARTZ_ICONS_NAME}.woff2" URL_HASH "SHA256=${QUARTZ_ICONS_HASH}" DOWNLOAD_NO_EXTRACT ON)
	FetchContent_MakeAvailable(quartz_icons)

	FetchContent_Declare(quartz_codepoints URL "${QUARTZ_ICONS_ARCHIVE}/${QUARTZ_ICONS_NAME}.codepoints" URL_HASH "SHA256=c2c8481ecb2134d6e29761b8d31b034e7e1e380c8eae514368cd794c22dd822b" DOWNLOAD_NO_EXTRACT ON)
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
