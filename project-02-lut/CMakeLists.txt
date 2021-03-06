cmake_minimum_required(VERSION 3.19)
project(project-02-lut VERSION 1.0.0)

find_package(verilator HINTS $ENV{VERILATOR_ROOT})

add_library(${PROJECT_NAME}-library STATIC)
target_compile_features(${PROJECT_NAME}-library PUBLIC cxx_std_11)
target_include_directories(${PROJECT_NAME}-library PUBLIC . ../verilatest)

set(VERILATEST_TARGET ${PROJECT_NAME}-library)
add_subdirectory(../verilatest verilatest)

verilate(${PROJECT_NAME}-library SOURCES And_Gate_Project.v TRACE)

# add_executable(clock_divider main.cpp)
# target_link_libraries(clock_divider PRIVATE lib_clock_divider)

find_package(Catch2 REQUIRED)
include(CTest)
include(Catch)

add_executable(${PROJECT_NAME}-tests
    test-lut.cpp
    ../common/test-common.hpp
    ../common/test-main.cpp
)

target_include_directories(${PROJECT_NAME}-tests PRIVATE ../common)
target_link_libraries(${PROJECT_NAME}-tests PRIVATE
    ${PROJECT_NAME}-library Catch2::Catch2)
catch_discover_tests(${PROJECT_NAME}-tests)    

# We check if this is the main file
# you don't usually want users of your library to
# execute tests as part of their build
# if (${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_CURRENT_SOURCE_DIR})
#     add_subdirectory(tests)
# endif ()
