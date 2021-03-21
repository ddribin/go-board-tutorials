#include "test-common.hpp"
#include "VClocked_Logic_Intro_tb.h"

using UUT = VClocked_Logic_Intro_tb;

static const uint8_t SwitchDown = 1;
static const uint8_t SwitchUp = 0;
static const uint8_t LedOff = 0;
static const uint8_t LedOn = 1;

TEST_CASE("[flip-flop] Initial state", "[project-03]")
{
    UUT core;

    core.eval();

    REQUIRE(core.o_LED_1 == LedOff);
}

TEST_CASE("[flip-flop] Switch down", "[project-03]")
{
    TestBench<UUT> bench;
    auto switchPublisher = makePublisher(&UUT::i_Switch_1);
    switchPublisher.addInputs({{1, SwitchDown}});
    auto ledObserver = makeObserver(&UUT::o_LED_1);

    bench.tick(10);

    ChangeVector8 expected;
    REQUIRE(ledObserver.changes() == expected);
}

TEST_CASE("[flip-flop] Switch down then up", "[project-03]")
{
    TestBench<UUT> bench;
    auto switchPublisher = makePublisher(&UUT::i_Switch_1);
    switchPublisher.addInputs({{1, SwitchDown}, {2, SwitchUp}});
    bench.addPreHook(switchPublisher.hook());

    auto ledObserver = makeObserver(&UUT::o_LED_1);
    bench.addPostHook(ledObserver.hook());

    bench.tick(10);

    ChangeVector8 expected{{2, LedOn}};
    REQUIRE(ledObserver.changes() == expected);
}

TEST_CASE("[flip-flop] Switch toggle 3 times", "[project-03]")
{
    TestBench<UUT> bench;
    auto switchPublisher = makePublisher(&UUT::i_Switch_1, {
        {1, SwitchDown}, {2,  SwitchUp},
        {4, SwitchDown}, {6,  SwitchUp},
        {8, SwitchDown}, {11, SwitchUp}
    });
    bench.addPreHook(switchPublisher.hook());
    auto ledObserver = makeObserver(&UUT::o_LED_1);
    bench.addPostHook(ledObserver.hook());
    
    bench.tick(15);

    ChangeVector8 expected{{2, LedOn}, {6, LedOff}, {11, LedOn}};
    REQUIRE(ledObserver.changes() == expected);
}
