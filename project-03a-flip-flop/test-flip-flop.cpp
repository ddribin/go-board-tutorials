#include "test-common.hpp"
#include "VSwitch.h"


struct VSwitch_Adapter : public VSwitch
{
    void setClock(uint64_t clock) { i_Clk = clock; }
};

using UUT = VSwitch_Adapter;

static const uint8_t SwitchDown = 1;
static const uint8_t SwitchUp = 0;
static const uint8_t LedOff = 0;
static const uint8_t LedOn = 1;

struct ClockedLogicFixture {
    using SignalPublisher8 = SignalPublisher<uint8_t, UUT>;
    using SignalObserver8 = SignalObserver<uint8_t, UUT>;
    TestBench<UUT> bench;
    UUT& core;
    SignalPublisher8 switch1;
    SignalObserver8 led1;

    ClockedLogicFixture() :
        core(bench.core()),
        switch1(&UUT::i_Switch),
        led1(&UUT::o_LED)
    {
        bench.addInput(switch1);
        bench.addOutput(led1);
    }
};
using Fixture = ClockedLogicFixture;

TEST_CASE_METHOD(Fixture, "[flip-flop2] Initial state", "[project-03]")
{
    REQUIRE(core.o_LED == LedOff);
}

TEST_CASE_METHOD(Fixture, "[flip-flop2] Switch down", "[project-03]")
{
    switch1.addInputs({{1, SwitchDown}});

    bench.tick(10);

    ChangeVector8 expected;
    REQUIRE(led1.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "[flip-flop2] Switch down then up", "[project-03]")
{
    switch1.addInputs({{1, SwitchDown}, {2, SwitchUp}});

    bench.tick(10);

    ChangeVector8 expected{{2, LedOn}};
    REQUIRE(led1.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "[flip-flop2] Switch toggle 3 times", "[project-03]")
{
    switch1.addInputs({
        {1, SwitchDown}, {2,  SwitchUp},
        {4, SwitchDown}, {6,  SwitchUp},
        {8, SwitchDown}, {11, SwitchUp}
    });
    
    bench.tick(15);

    ChangeVector8 expected{{2, LedOn}, {6, LedOff}, {11, LedOn}};
    REQUIRE(led1.changes() == expected);
}
