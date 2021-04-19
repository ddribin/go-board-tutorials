cmake_minimum_required(VERSION 3.19)
project(project-05a-7sd VERSION 1.0.0)

find_package(verilator HINTS $ENV{VERILATOR_ROOT})

add_library(${PROJECT_NAME}-library STATIC)
target_compile_features(${PROJECT_NAME}-library PUBLIC cxx_std_14)
target_include_directories(${PROJECT_NAME}-library PUBLIC . ../verilatest)

set(VERILATEST_TARGET ${PROJECT_NAME}-library)
add_subdirectory(../verilatest verilatest)

verilate(${PROJECT_NAME}-library SOURCES rtl/Count_7SD_Top.v INCLUDE_DIRS rtl)
verilate(${PROJECT_NAME}-library SOURCES rtl/Nibble_To_7SD.v INCLUDE_DIRS rtl)
verilate(${PROJECT_NAME}-library SOURCES rtl/Switch_Counter.v INCLUDE_DIRS rtl)
verilate(${PROJECT_NAME}-library SOURCES rtl/Bit_Counter.v INCLUDE_DIRS rtl)
verilate(${PROJECT_NAME}-library SOURCES Auto_Counter_tb.v INCLUDE_DIRS rtl)
verilate(${PROJECT_NAME}-library SOURCES State_Machine_tb.v INCLUDE_DIRS rtl)

find_package(Catch2 REQUIRED)
include(CTest)
include(Catch)

add_executable(${PROJECT_NAME}-tests
    test-nibble-to-7sd.cpp
    test-switch-counter.cpp
    test-bit-counter.cpp
    test-auto-counter.cpp
    test-state-machine.cpp
    ../common/test-common.hpp
    ../common/test-main.cpp
)
target_compile_definitions(${PROJECT_NAME}-tests PRIVATE VERILATEST_TRACE=0)
target_include_directories(${PROJECT_NAME}-tests PRIVATE ../common)
target_link_libraries(${PROJECT_NAME}-tests PRIVATE
    ${PROJECT_NAME}-library Catch2::Catch2)
catch_discover_tests(${PROJECT_NAME}-tests)
