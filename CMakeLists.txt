cmake_minimum_required(VERSION 3.27)
project(quartz VERSION 0.1 DESCRIPTION "A modern Qt Quick library")

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

option(QUARTZ_NO_ICONS "Do not bundle icons." OFF)

add_subdirectory(src)
