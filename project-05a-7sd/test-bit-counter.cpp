#include "test-common.hpp"
#include "VBit_Counter.h"

struct VBit_Counter_Adapter : public VBit_Counter
{
    void setClock(uint64_t clock) { i_Clk = clock; }
};

using UUT = VBit_Counter_Adapter;

struct BitCounterFixture {
    using SignalPublisher8 = SignalPublisher<uint8_t, UUT>;
    using SignalObserver8 = SignalObserver<uint8_t, UUT>;
    TestBench<UUT> bench;
    UUT& core;
    SignalPublisher8 reset;
    SignalPublisher8 switch1;
    SignalPublisher8 switch2;
    SignalPublisher8 switch3;
    SignalPublisher8 switch4;
    SignalObserver8 nibble;
    BitCounterFixture() :
        core(bench.core()),
        reset(&UUT::i_Reset),
        switch1(&UUT::i_Switch_1),
        switch2(&UUT::i_Switch_2),
        switch3(&UUT::i_Switch_3),
        switch4(&UUT::i_Switch_4),
        nibble(&UUT::o_Nibble)
    {
        bench.addInput(reset);
        bench.addInput(switch1);
        bench.addInput(switch2);
        bench.addInput(switch3);
        bench.addInput(switch4);
        bench.addOutput(nibble);

    };
};

using Fixture = BitCounterFixture;

static const uint8_t SwitchUp = 0;
static const uint8_t SwitchDown = 1;


TEST_CASE_METHOD(Fixture, "[bit-counter] Initial state", "[project-05a]")
{
    REQUIRE(core.o_Nibble == 0x0);
}

TEST_CASE_METHOD(Fixture, "[bit-counter] Switch 1", "[project-05a]")
{
    switch1.addInputs({
        {2, SwitchDown}, {3, SwitchUp}, {4, SwitchDown}, {5, SwitchUp},
    });

    bench.tick(10);

    ChangeVector8 expected({{2, 0x1}, {4, 0x0}});
    REQUIRE(nibble.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "[bit-counter] Switch 2", "[project-05a]")
{
    switch2.addInputs({
        {2, SwitchDown}, {3, SwitchUp}, {4, SwitchDown}, {5, SwitchUp},
    });

    bench.tick(10);

    ChangeVector8 expected({{2, 0x2}, {4, 0x0}});
    REQUIRE(nibble.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "[bit-counter] Switch 3", "[project-05a]")
{
    switch3.addInputs({
        {2, SwitchDown}, {3, SwitchUp}, {4, SwitchDown}, {5, SwitchUp},
    });

    bench.tick(10);

    ChangeVector8 expected({{2, 0x4}, {4, 0x0}});
    REQUIRE(nibble.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "[bit-counter] Switch 4", "[project-05a]")
{
    switch4.addInputs({
        {2, SwitchDown}, {3, SwitchUp}, {4, SwitchDown}, {5, SwitchUp},
    });

    bench.tick(10);

    ChangeVector8 expected({{2, 0x8}, {4, 0x0}});
    REQUIRE(nibble.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "[bit-counter] Multiple switches", "[project-05a]")
{
    switch1.addInputs({
        {2, SwitchDown}, {8, SwitchUp}, {10, SwitchDown}, {15, SwitchUp},
    });
    switch3.addInputs({
        {4, SwitchDown}, {5, SwitchUp}, {12, SwitchDown}, {16, SwitchUp},
    });

    bench.tick(20);

    ChangeVector8 expected({{2, 0x1}, {4, 0x5}, {10, 0x4}, {12, 0x0}});
    REQUIRE(nibble.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "[bit-counter] Reset", "[project-05a]")
{
    switch1.addInputs({
        {2, SwitchDown}, {8, SwitchUp}, {20, SwitchDown}, {25, SwitchUp},
    });
    switch3.addInputs({
        {4, SwitchDown}, {5, SwitchUp}, {22, SwitchDown}, {26, SwitchUp},
    });
    reset.addInputs({{10, 1}, {12, 0}});

    bench.tick(30);

    ChangeVector8 expected({{2, 0x1}, {4, 0x5}, {10, 0x0}, {20, 0x1}, {22, 0x5}});
    REQUIRE(nibble.changes() == expected);
}
