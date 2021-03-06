cmake_minimum_required(VERSION 3.19)
project(project-05-7sd VERSION 1.0.0)

find_package(verilator HINTS $ENV{VERILATOR_ROOT})

add_library(${PROJECT_NAME}-library STATIC)
target_compile_features(${PROJECT_NAME}-library PUBLIC cxx_std_14)
target_include_directories(${PROJECT_NAME}-library PUBLIC . ../verilatest)

set(VERILATEST_TARGET ${PROJECT_NAME}-library)
add_subdirectory(../verilatest verilatest)

set(TRACE_ENABLED 0)
verilate(${PROJECT_NAME}-library SOURCES Project_7_Segment_Top.v)
verilate(${PROJECT_NAME}-library SOURCES Binary_To_7Segment.v)

find_package(Catch2 REQUIRED)
include(CTest)
include(Catch)

add_executable(${PROJECT_NAME}-tests
    test-binary-to-7segment.cpp
    ../common/test-common.hpp
    ../common/test-main.cpp
)

if(NOT TRACE_ENABLED)
    target_compile_definitions(${PROJECT_NAME}-tests PRIVATE VERILATEST_TRACE=0)
endif()
target_include_directories(${PROJECT_NAME}-tests PRIVATE ../common)
target_link_libraries(${PROJECT_NAME}-tests PRIVATE
    ${PROJECT_NAME}-library Catch2::Catch2)
catch_discover_tests(${PROJECT_NAME}-tests)
