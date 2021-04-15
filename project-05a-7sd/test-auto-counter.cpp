#include "test-common.hpp"
#include "VAuto_Counter_tb.h"

struct VAuto_Counter_Adapter : public VAuto_Counter_tb
{
    void setClock(uint64_t clock) { i_Clk = clock; }
};

using UUT = VAuto_Counter_Adapter;

struct AutoCounterFixture {
    using SignalPublisher8 = SignalPublisher<uint8_t, UUT>;
    using SignalObserver8 = SignalObserver<uint8_t, UUT>;
    TestBench<UUT> bench;
    UUT& core;
    SignalObserver8 nibble;
    AutoCounterFixture() :
        core(bench.core()),
        nibble(&UUT::o_Nibble)
    {
        bench.addOutput(nibble);
    };
};

using Fixture = AutoCounterFixture;

static const uint8_t SwitchUp = 0;
static const uint8_t SwitchDown = 1;


TEST_CASE_METHOD(Fixture, "[auto-counter] Initial state", "[project-05a]")
{
    REQUIRE(core.o_Nibble == 0x0);
}

TEST_CASE_METHOD(Fixture, "[auto-counter] Two delay cycles", "[project-05a]")
{
    bench.tick(12);

    ChangeVector8 expected({{5, 0x1}, { 10, 0x2}});
    REQUIRE(nibble.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "[auto-counter] Wraps around at 0xF", "[project-05a]")
{
    bench.tick(102);

    ChangeVector8 expected({
        {5,  0x1}, {10, 0x2}, {15, 0x3}, {20, 0x4},
        {25, 0x5}, {30, 0x6}, {35, 0x7}, {40, 0x8},
        {45, 0x9}, {50, 0xA}, {55, 0xB}, {60, 0xC},
        {65, 0xD}, {70, 0xE}, {75, 0xF}, {80, 0x0},
        {85, 0x1}, {90, 0x2}, {95, 0x3}, {100, 0x4},
    });
    REQUIRE(nibble.changes() == expected);
}
