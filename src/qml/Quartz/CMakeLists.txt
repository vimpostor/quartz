list(APPEND QUARTZ_QT_MODULES Core Qml Quick QuickControls2)
find_package(Qt6 6.11 COMPONENTS ${QUARTZ_QT_MODULES} REQUIRED)
qt_standard_project_setup(REQUIRES ${Qt6_VERSION})
list(TRANSFORM QUARTZ_QT_MODULES PREPEND "Qt6::")

add_compile_definitions(QUARTZ_VERSION="${PROJECT_VERSION}")

file(GLOB_RECURSE SRCS "../../quartz/*.cpp")
file(GLOB_RECURSE HDRS "../../quartz/*.hpp")
file(GLOB_RECURSE QMLS RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "*.qml")

set_source_files_properties(Icons.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_library("${PROJECT_NAME}" STATIC)

target_include_directories("${PROJECT_NAME}" PUBLIC "../..")
target_include_directories("${PROJECT_NAME}" PRIVATE "../../quartz")
target_link_libraries("${PROJECT_NAME}" PRIVATE ${QUARTZ_QT_MODULES})

qt_add_qml_module("${PROJECT_NAME}" URI "Quartz" VERSION "${PROJECT_VERSION}" QML_FILES ${QMLS} SOURCES ${SRCS} ${HDRS})
set_target_properties("${PROJECT_NAME}" PROPERTIES QT_QMLCACHEGEN_ARGUMENTS "--only-bytecode")

# Bundle material design icons
function(quartz_bundle_icons target style)
	include(FetchContent)

	set(QUARTZ_ICONS_ARCHIVE "https://github.com/google/material-design-icons/raw/481507587f1bdfe712939398c4dc0ecc2079ea7c/variablefont")
	set(QUARTZ_ICONS_NAME "MaterialSymbols${style}%5BFILL,GRAD,opsz,wght%5D")
	set(QUARTZ_ICONS_TYPE "ttf")

	set(QUARTZ_ICONS_HASH "d7bf8250a14168acddf65ac9e75a2c9c2e8df5e10119560828698728eb12d917") # Outlined
	if (style EQUAL "Rounded")
		set(QUARTZ_ICONS_HASH "8a80aaeaabf58ee64face224cb4ff56f756e7581f656b9ceff27918218408f25") # Rounded
	elseif (style EQUAL "Sharp")
		set(QUARTZ_ICONS_HASH "e812489e2e2101bcb5fedb93075a2cfe2528d36b8c00456f15fa3050e2aca9b8") # Sharp
	endif()
	FetchContent_Declare(quartz_icons URL "${QUARTZ_ICONS_ARCHIVE}/${QUARTZ_ICONS_NAME}.${QUARTZ_ICONS_TYPE}" URL_HASH "SHA256=${QUARTZ_ICONS_HASH}" DOWNLOAD_NO_EXTRACT ON)
	FetchContent_MakeAvailable(quartz_icons)

	set(QUARTZ_ICONS_CODEPOINTS_HASH "441f782d0e16325739a299e61d9431999b597fb2e6d75afa8a170cad32a957a9") # codepoints
	FetchContent_Declare(quartz_codepoints URL "${QUARTZ_ICONS_ARCHIVE}/${QUARTZ_ICONS_NAME}.codepoints" URL_HASH "SHA256=${QUARTZ_ICONS_CODEPOINTS_HASH}" DOWNLOAD_NO_EXTRACT ON)
	FetchContent_MakeAvailable(quartz_codepoints)

	# relative paths are required for QRC
	cmake_path(RELATIVE_PATH quartz_icons_SOURCE_DIR)
	set_source_files_properties("${quartz_icons_SOURCE_DIR}/${QUARTZ_ICONS_NAME}.${QUARTZ_ICONS_TYPE}" PROPERTIES QT_RESOURCE_ALIAS "MaterialSymbols.${QUARTZ_ICONS_TYPE}")
	cmake_path(RELATIVE_PATH quartz_codepoints_SOURCE_DIR)
	set_source_files_properties("${quartz_codepoints_SOURCE_DIR}/${QUARTZ_ICONS_NAME}.codepoints" PROPERTIES QT_RESOURCE_ALIAS "MaterialSymbols.codepoints")

	qt_add_resources("${target}" quartz_icons FILES "${quartz_icons_SOURCE_DIR}/${QUARTZ_ICONS_NAME}.${QUARTZ_ICONS_TYPE}" "${quartz_codepoints_SOURCE_DIR}/${QUARTZ_ICONS_NAME}.codepoints")
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

function(quartz_bundle_android_openssl target)
	if (ANDROID)
		FetchContent_Declare(android_openssl URL https://github.com/kdab/android_openssl/archive/refs/heads/master.zip)
		FetchContent_MakeAvailable(android_openssl)
		include(${android_openssl_SOURCE_DIR}/android_openssl.cmake)
		add_android_openssl_libraries("${target}")
	endif()
endfunction()

function(quartz_generate_launcher_icons target)
	list(APPEND IMAGEMAGICK_PREFIX "magick" "-background" "none" "${CMAKE_SOURCE_DIR}/assets/${target}.svg" "-resize")
	if (ANDROID)
		list(APPEND ICON_COMMANDS COMMAND "sh" "-c" "mkdir -p ${CMAKE_SOURCE_DIR}/android/res/drawable-\\{l,m,h,xh,xxh,xxxh\\}dpi")
		list(APPEND ICON_COMMANDS COMMAND ${IMAGEMAGICK_PREFIX} "36x36" "${CMAKE_SOURCE_DIR}/android/res/drawable-ldpi/${target}.png")
		list(APPEND ICON_COMMANDS COMMAND ${IMAGEMAGICK_PREFIX} "48x48" "${CMAKE_SOURCE_DIR}/android/res/drawable-mdpi/${target}.png")
		list(APPEND ICON_COMMANDS COMMAND ${IMAGEMAGICK_PREFIX} "72x72" "${CMAKE_SOURCE_DIR}/android/res/drawable-hdpi/${target}.png")
		list(APPEND ICON_COMMANDS COMMAND ${IMAGEMAGICK_PREFIX} "96x96" "${CMAKE_SOURCE_DIR}/android/res/drawable-xhdpi/${target}.png")
		list(APPEND ICON_COMMANDS COMMAND ${IMAGEMAGICK_PREFIX} "144x144" "${CMAKE_SOURCE_DIR}/android/res/drawable-xxhdpi/${target}.png")
		list(APPEND ICON_COMMANDS COMMAND ${IMAGEMAGICK_PREFIX} "192x192" "${CMAKE_SOURCE_DIR}/android/res/drawable-xxxhdpi/${target}.png")
	elseif (LINUX)
		list(APPEND ICON_SIZES 16 32 48 64 128 256 512)
		foreach(ICON_SIZE IN LISTS ICON_SIZES)
			list(APPEND ICON_COMMANDS COMMAND ${IMAGEMAGICK_PREFIX} "${ICON_SIZE}x${ICON_SIZE}" "${ICON_SIZE}.png")
			install(FILES "${CMAKE_BINARY_DIR}/${ICON_SIZE}.png" DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/${ICON_SIZE}x${ICON_SIZE}/apps" RENAME "${target}.png")
		endforeach()
	endif()
	add_custom_target(icon-integration ${ICON_COMMANDS})
endfunction()

function(quartz_generate_desktop_file target categories)
	string(SUBSTRING "${target}" 0 1 FIRST_LETTER)
	string(TOUPPER "${FIRST_LETTER}" FIRST_LETTER)
	string(SUBSTRING "${target}" 1 -1 REST_LETTER)
	string(APPEND PROJECT_NAME_CAPITALIZED "${FIRST_LETTER}${REST_LETTER}")
	file(CONFIGURE OUTPUT "${CMAKE_BINARY_DIR}/${PROJECT_NAME}.desktop" CONTENT "#!/usr/bin/env xdg-open\n[Desktop Entry]\nType=Application\nName=@PROJECT_NAME_CAPITALIZED@\nComment=@PROJECT_DESCRIPTION@\nExec=@target@\nTerminal=false\nCategories=@categories@\nIcon=@target@" @ONLY NEWLINE_STYLE UNIX)
	install(FILES "${CMAKE_BINARY_DIR}/${PROJECT_NAME}.desktop" DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/applications")
endfunction()

# install is currently broken, because QML modules cannot be installed systemwide in the filesystem
# As a workaround, all projects should include this project with FetchContent, which builds it and statically links against it.
# When QML modules get install support, we can uncomment this and start porting projects from FetchContent to native install.
# Until then, the following line should stay commented as it would cause FetchContent projects to install libquartz systemwide, which clashes once we want to install more than one Quartz project on the system.
# install(TARGETS "${PROJECT_NAME}")
