#include "test-common.hpp"
#include "VDebounce_Project_tb.h"


struct VDebounce_Project_Top_Adapter : public VDebounce_Project_tb
{
    void setClock(uint64_t clock) { i_Clk = clock; }
};

using UUT = VDebounce_Project_Top_Adapter;

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
        switch1(&UUT::i_Switch_1),
        led1(&UUT::o_LED_1)
    {
        bench.addInput(switch1);
        bench.addOutput(led1);
    }
};

using Fixture = ClockedLogicFixture;

TEST_CASE_METHOD(Fixture, "[debounce2] Switch down", "[project-04a]")
{
    switch1.addInputs({{1, SwitchDown}});

    bench.tick(10);

    ChangeVector8 expected;
    REQUIRE(led1.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "[debounce2] Switch down then up before timeout", "[project-04a]")
{
    switch1.addInputs({{1, SwitchDown}, {2, SwitchUp}});

    bench.tick(10);

    ChangeVector8 expected;
    REQUIRE(led1.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "[debounce2] Switch down then up just before timeout", "[project-04a]")
{
    switch1.addInputs({{1, SwitchDown}, {11, SwitchUp}});

    bench.tick(30);

    ChangeVector8 expected;
    REQUIRE(led1.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "[debounce2] Switch down then up just after timeout", "[project-04a]")
{
    switch1.addInputs({{1, SwitchDown}, {12, SwitchUp}});

    bench.tick(30);

    ChangeVector8 expected{{23, LedOn}};
    REQUIRE(led1.changes() == expected);
}
