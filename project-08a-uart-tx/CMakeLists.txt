cmake_minimum_required(VERSION 3.19)
project(project-08a-uart-tx VERSION 1.0.0)

find_package(verilator HINTS $ENV{VERILATOR_ROOT})

add_library(${PROJECT_NAME}-library STATIC)
target_compile_features(${PROJECT_NAME}-library PUBLIC cxx_std_14)
target_include_directories(${PROJECT_NAME}-library PUBLIC . ../verilatest)

set(VERILATEST_TARGET ${PROJECT_NAME}-library)
add_subdirectory(../verilatest verilatest)

set(TRACE_ENABLED 1)
verilate(${PROJECT_NAME}-library SOURCES UART_Transmitter_tb.v TRACE $TRACE_ENABLED)
verilate(${PROJECT_NAME}-library SOURCES FIFO_2word_FWFT.sv TRACE $TRACE_ENABLED)
verilate(${PROJECT_NAME}-library SOURCES UART_Loopback_Top.v TRACE $TRACE_ENABLED)

find_package(Catch2 REQUIRED)
include(CTest)
include(Catch)

add_executable(${PROJECT_NAME}-tests
    test-uart-transmitter.cpp
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
