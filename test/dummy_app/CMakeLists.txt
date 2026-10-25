cmake_minimum_required(VERSION 3.24)

project(dummy_app LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(Qt6 REQUIRED Core)

qt_add_executable(dummy_app main.cpp)

set_target_properties(dummy_app PROPERTIES WIN32_EXECUTABLE FALSE)

target_link_libraries(dummy_app PRIVATE Qt6::Core)
