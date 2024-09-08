list(APPEND QUARTZ_QT_MODULES Core Qml Quick QuickControls2)
find_package(Qt6 6.7 COMPONENTS ${QUARTZ_QT_MODULES} REQUIRED)
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

	set(QUARTZ_ICONS_ARCHIVE "https://github.com/google/material-design-icons/raw/e9da2194e65080a829d670ae39a99c7b5fc09548/variablefont")
	set(QUARTZ_ICONS_NAME "MaterialSymbols${style}%5BFILL,GRAD,opsz,wght%5D")

	set(QUARTZ_ICONS_HASH "ec1106037ca4159ea54a8e3279f49fd9058d2c62575e0589f01b4e39fd870e2a") # Outlined
	if (style EQUAL "Rounded")
		set(QUARTZ_ICONS_HASH "d5f979a1a5aae499c402de14c288444ef0888a6cecc0e6ff8b9108384f456460") # Rounded
	elseif (style EQUAL "Sharp")
		set(QUARTZ_ICONS_HASH "6e31a88fd5ba964dfa6aa302adec3d37db761562fce2143d5cc425d8cd8d73ca") # Sharp
	endif()
	FetchContent_Declare(quartz_icons URL "${QUARTZ_ICONS_ARCHIVE}/${QUARTZ_ICONS_NAME}.woff2" URL_HASH "SHA256=${QUARTZ_ICONS_HASH}" DOWNLOAD_NO_EXTRACT ON)
	FetchContent_MakeAvailable(quartz_icons)

	set(QUARTZ_ICONS_CODEPOINTS_HASH "38a3da4dbc48fc5169d7b06fe346729aa05499081c818e5d04b716819f431b84") # codepoints
	FetchContent_Declare(quartz_codepoints URL "${QUARTZ_ICONS_ARCHIVE}/${QUARTZ_ICONS_NAME}.codepoints" URL_HASH "SHA256=${QUARTZ_ICONS_CODEPOINTS_HASH}" DOWNLOAD_NO_EXTRACT ON)
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
