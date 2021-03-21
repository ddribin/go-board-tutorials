#include "test-common.hpp"
#include "VAnd_Gate_Project.h"

TEST_CASE("[lut] Initial state", "[project-02")
{
    VAnd_Gate_Project core;

    core.eval();

    REQUIRE(core.o_LED_1 == 0);
}

TEST_CASE("[lut] Only switch 1 on", "[project-02]")
{
    VAnd_Gate_Project core;

    core.i_Switch_1 = 1;
    core.eval();

    REQUIRE(core.o_LED_1 == 0);
}

TEST_CASE("[lut] Only switch 2 on", "[project-02]")
{
    VAnd_Gate_Project core;

    core.i_Switch_2 = 1;
    core.eval();

    REQUIRE(core.o_LED_1 == 0);
}

TEST_CASE("[lut] Both switches on", "[project-02]")
{
    VAnd_Gate_Project core;

    core.i_Switch_1 = 1;
    core.i_Switch_2 = 1;
    core.eval();

    REQUIRE(core.o_LED_1 == 1);
}
