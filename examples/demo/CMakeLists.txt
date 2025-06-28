cmake_minimum_required(VERSION 4.0)
project(demo VERSION 1.0)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_subdirectory(quartz)
add_subdirectory(src/Demo)

# install
install(TARGETS "${PROJECT_NAME}" RUNTIME)
install(FILES "assets/${PROJECT_NAME}.desktop" DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/applications")
