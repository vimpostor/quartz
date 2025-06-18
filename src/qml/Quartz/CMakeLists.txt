list(APPEND QUARTZ_QT_MODULES Core Qml Quick QuickControls2)
find_package(Qt6 6.9 COMPONENTS ${QUARTZ_QT_MODULES} REQUIRED)
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

	set(QUARTZ_ICONS_ARCHIVE "https://github.com/google/material-design-icons/raw/941fa95d7f6084a599a54ca71bc565f48e7c6d9e/variablefont")
	set(QUARTZ_ICONS_NAME "MaterialSymbols${style}%5BFILL,GRAD,opsz,wght%5D")
	set(QUARTZ_ICONS_TYPE "ttf")

	set(QUARTZ_ICONS_HASH "396974c0c6367d3fb7bdf66fed1372c6b05a48a23e48bc4f48919c66184fe011") # Outlined
	if (style EQUAL "Rounded")
		set(QUARTZ_ICONS_HASH "4b7a9c0647fabf1ef8f109b88e4eef393c0018e72957a655c4b690c298bf565c") # Rounded
	elseif (style EQUAL "Sharp")
		set(QUARTZ_ICONS_HASH "7ea86a158253c9b0a13ebf209bc9524faf4a6561a2fec4b7a022972b73fe37b1") # Sharp
	endif()
	FetchContent_Declare(quartz_icons URL "${QUARTZ_ICONS_ARCHIVE}/${QUARTZ_ICONS_NAME}.${QUARTZ_ICONS_TYPE}" URL_HASH "SHA256=${QUARTZ_ICONS_HASH}" DOWNLOAD_NO_EXTRACT ON)
	FetchContent_MakeAvailable(quartz_icons)

	set(QUARTZ_ICONS_CODEPOINTS_HASH "a485bcf86b9e5bcba43aa2783d5bdefce19f4640e5fc4e1332f687cb86192a1e") # codepoints
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

function(quartz_generate_android_icons target)
	if (ANDROID)
		list(APPEND ICON_COMMANDS COMMAND "sh" "-c" "mkdir -p ${CMAKE_BINARY_DIR}/android/res/drawable-\\{l,m,h,xh,xxh,xxxh\\}dpi")
		list(APPEND ICON_COMMANDS COMMAND "magick" "${CMAKE_SOURCE_DIR}/assets/${target}.svg" "-resize" "36x36" "${CMAKE_BINARY_DIR}/android/res/drawable-ldpi/${target}.png")
		list(APPEND ICON_COMMANDS COMMAND "magick" "${CMAKE_SOURCE_DIR}/assets/${target}.svg" "-resize" "48x48" "${CMAKE_BINARY_DIR}/android/res/drawable-mdpi/${target}.png")
		list(APPEND ICON_COMMANDS COMMAND "magick" "${CMAKE_SOURCE_DIR}/assets/${target}.svg" "-resize" "72x72" "${CMAKE_BINARY_DIR}/android/res/drawable-hdpi/${target}.png")
		list(APPEND ICON_COMMANDS COMMAND "magick" "${CMAKE_SOURCE_DIR}/assets/${target}.svg" "-resize" "96x96" "${CMAKE_BINARY_DIR}/android/res/drawable-xhdpi/${target}.png")
		list(APPEND ICON_COMMANDS COMMAND "magick" "${CMAKE_SOURCE_DIR}/assets/${target}.svg" "-resize" "144x144" "${CMAKE_BINARY_DIR}/android/res/drawable-xxhdpi/${target}.png")
		list(APPEND ICON_COMMANDS COMMAND "magick" "${CMAKE_SOURCE_DIR}/assets/${target}.svg" "-resize" "192x192" "${CMAKE_BINARY_DIR}/android/res/drawable-xxxhdpi/${target}.png")
		add_custom_target(android-integration ${ICON_COMMANDS})
	endif()
endfunction()

# install is currently broken, because QML modules cannot be installed systemwide in the filesystem
# As a workaround, all projects should include this project with FetchContent, which builds it and statically links against it.
# When QML modules get install support, we can uncomment this and start porting projects from FetchContent to native install.
# Until then, the following line should stay commented as it would cause FetchContent projects to install libquartz systemwide, which clashes once we want to install more than one Quartz project on the system.
# install(TARGETS "${PROJECT_NAME}")
