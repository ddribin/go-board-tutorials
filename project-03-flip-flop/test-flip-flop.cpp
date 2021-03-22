#include "test-common.hpp"
#include "VClocked_Logic_tb.h"

using UUT = VClocked_Logic_tb;

static const uint8_t SwitchDown = 1;
static const uint8_t SwitchUp = 0;
static const uint8_t LedOff = 0;
static const uint8_t LedOn = 1;

struct ClockedLogicFixture {
    using SignalPublisher8 = SignalPublisher<uint8_t, UUT>;
    using SignalObserver8 = SignalObserver<uint8_t, UUT>;
    TestBench<UUT> bench;
    SignalPublisher8 switchInput;
    SignalObserver8 ledOutput;

    ClockedLogicFixture() :
        switchInput(&UUT::i_Switch_1),
        ledOutput(&UUT::o_LED_1)
    {
        bench.addPreHook(switchInput.hook());
        bench.addPostHook(ledOutput.hook());
    }
};
using Fixture = ClockedLogicFixture;

TEST_CASE("[flip-flop] Initial state", "[project-03]")
{
    UUT core;

    core.eval();

    REQUIRE(core.o_LED_1 == LedOff);
}

TEST_CASE_METHOD(Fixture, "[flip-flop] Switch down", "[project-03]")
{
    switchInput.addInputs({{1, SwitchDown}});

    bench.tick(10);

    ChangeVector8 expected;
    REQUIRE(ledOutput.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "[flip-flop] Switch down then up", "[project-03]")
{
    switchInput.addInputs({{1, SwitchDown}, {2, SwitchUp}});

    bench.tick(10);

    ChangeVector8 expected{{2, LedOn}};
    REQUIRE(ledOutput.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "[flip-flop] Switch toggle 3 times", "[project-03]")
{
    switchInput.addInputs({
        {1, SwitchDown}, {2,  SwitchUp},
        {4, SwitchDown}, {6,  SwitchUp},
        {8, SwitchDown}, {11, SwitchUp}
    });
    
    bench.tick(15);

    ChangeVector8 expected{{2, LedOn}, {6, LedOff}, {11, LedOn}};
    REQUIRE(ledOutput.changes() == expected);
}
