cmake_minimum_required(VERSION 3.19)
project(project-10-pong VERSION 1.0.0)

find_package(verilator HINTS $ENV{VERILATOR_ROOT})

add_library(${PROJECT_NAME}-library STATIC)
target_compile_features(${PROJECT_NAME}-library PUBLIC cxx_std_14)
target_include_directories(${PROJECT_NAME}-library PUBLIC . ../verilatest)

set(VERILATEST_TARGET ${PROJECT_NAME}-library)
add_subdirectory(../verilatest verilatest)

set(TRACE_ENABLED 0)
verilate(${PROJECT_NAME}-library SOURCES Project10_Pong_Top.v TRACE $TRACE_ENABLED)
