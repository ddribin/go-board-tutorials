#include "test-common.hpp"
#include "VSwitch_Counter.h"

struct VSwitch_Counter_Adapter : public VSwitch_Counter
{
    void setClock(uint64_t clock) { i_Clk = clock; }
};

using UUT = VSwitch_Counter_Adapter;

struct SwitchCounterFixture {
    using SignalPublisher8 = SignalPublisher<uint8_t, UUT>;
    using SignalObserver8 = SignalObserver<uint8_t, UUT>;
    TestBench<UUT> bench;
    UUT& core;
    SignalPublisher8 reset;
    SignalPublisher8 swtch;
    SignalObserver8 nibble;
    SwitchCounterFixture() :
        core(bench.core()),
        reset(&UUT::i_Reset),
        swtch(&UUT::i_Switch),
        nibble(&UUT::o_Nibble)
    {
        bench.addInput(reset);
        bench.addInput(swtch);
        bench.addOutput(nibble);
    };
};

using Fixture = SwitchCounterFixture;

static const uint8_t SwitchUp = 0;
static const uint8_t SwitchDown = 1;


TEST_CASE_METHOD(Fixture, "[switch-counter] Initial state", "[project-05a]")
{
    REQUIRE(core.o_Nibble == 0x0);
}

TEST_CASE_METHOD(Fixture, "[switch-counter] Switch down", "[project-05a]")
{
    swtch.addInputs({{1, SwitchDown}});

    bench.tick(2);

    ChangeVector8 expected({{1, 0x1}});
    REQUIRE(nibble.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "[switch-counter] Switch down then up", "[project-05a]")
{
    swtch.addInputs({{2, SwitchDown}, {4, SwitchUp}});

    bench.tick(10);

    ChangeVector8 expected({{2, 0x1}});
    REQUIRE(nibble.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "[switch-counter] Switch pressed multiple times", "[project-05a]")
{
    swtch.addInputs({
        {2,  SwitchDown}, {4,  SwitchUp},
        {6,  SwitchDown}, {8,  SwitchUp},
        {10, SwitchDown}, {12, SwitchUp},
    });

    bench.tick(20);

    ChangeVector8 expected({{2, 0x1}, {6, 0x2}, {10, 0x3}});
    REQUIRE(nibble.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "[switch-counter] Nibble wraps around at 9", "[project-05a]")
{
    swtch.addInputs({
        {2,  SwitchDown}, {3,  SwitchUp}, {4,  SwitchDown}, {5,  SwitchUp},
        {6,  SwitchDown}, {7,  SwitchUp}, {8,  SwitchDown}, {9,  SwitchUp},
        {10, SwitchDown}, {11, SwitchUp}, {12, SwitchDown}, {13, SwitchUp},
        {14, SwitchDown}, {15, SwitchUp}, {16, SwitchDown}, {17, SwitchUp},
        {18, SwitchDown}, {19, SwitchUp}, {20, SwitchDown}, {21, SwitchUp},
    });

    bench.tick(30);

    ChangeVector8 expected({
        {2,  0x1}, {4,  0x2}, {6,  0x3}, {8,  0x4}, {10, 0x5},
        {12, 0x6}, {14, 0x7}, {16, 0x8}, {18, 0x9}, {20, 0x0},
    });
    REQUIRE(nibble.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "[switch-counter] Reset after some counting", "[project-05a]")
{
    swtch.addInputs({
        {2,  SwitchDown}, {4,  SwitchUp},
        {16, SwitchDown}, {18,  SwitchUp},
        {20, SwitchDown}, {22, SwitchUp},
    });
    reset.addInputs({{6, 1}, {10, 0}});

    bench.tick(30);

    ChangeVector8 expected({{2, 0x1}, {6, 0x0}, {16, 0x1}, {20, 0x2}});
    REQUIRE(nibble.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "[switch-counter] Reset overlaps switch presses", "[project-05a]")
{
    swtch.addInputs({
        {2,  SwitchDown}, {4,  SwitchUp},
        {6,  SwitchDown}, {8,  SwitchUp},
        {10, SwitchDown}, {12, SwitchUp},
        {14, SwitchDown}, {16, SwitchUp},
    });
    reset.addInputs({{5, 1}, {11, 0}});

    bench.tick(30);

    ChangeVector8 expected({{2, 0x1}, {5, 0x0}, {14, 0x1}});
    REQUIRE(nibble.changes() == expected);
}
