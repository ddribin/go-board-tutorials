
#include "test-common.hpp"
#include "VSwitches_To_LEDs.h"

TEST_CASE("[led] Initial state", "[project-01]")
{
    VSwitches_To_LEDs core;

    core.eval();

    REQUIRE(core.o_LED_1 == 0);
    REQUIRE(core.o_LED_2 == 0);
    REQUIRE(core.o_LED_3 == 0);
    REQUIRE(core.o_LED_4 == 0);
}

TEST_CASE("[led] Test change switches", "[project-01]")
{
    VSwitches_To_LEDs core;
    core.i_Switch_1 = 1;
    core.i_Switch_3 = 1;
    
    core.eval();

    REQUIRE(core.o_LED_1 == 1);
    REQUIRE(core.o_LED_2 == 0);
    REQUIRE(core.o_LED_3 == 1);
    REQUIRE(core.o_LED_4 == 0);
}