#include "test-common.hpp"
#include "VState_Machine_tb.h"

struct VState_Machine_Adapter : public VState_Machine_tb
{
    void setClock(uint64_t clock) { i_Clk = clock; }
};

using UUT = VState_Machine_Adapter;

struct StateMachineFixture {
    using SignalPublisher8 = SignalPublisher<uint8_t, UUT>;
    using SignalObserver8 = SignalObserver<uint8_t, UUT>;
    TestBench<UUT> bench;
    UUT& core;
    SignalPublisher8 switches;
    SignalObserver8 state;
    SignalObserver8 segments;
    StateMachineFixture() :
        core(bench.core()),
        switches(&UUT::i_Switches),
        state(&UUT::o_State),
        segments(&UUT::o_Segments)
    {
        bench.addInput(switches);
        bench.addOutput(state);
        bench.addOutput(segments);
    };
};

using Fixture = StateMachineFixture;

static const uint8_t Switch1 = 0b0001;
static const uint8_t Switch2 = 0b0010;
static const uint8_t Switch3 = 0b0100;
static const uint8_t Switch4 = 0b1000;

enum Segment : uint8_t {
    SegmentA = 0b0000001,
    SegmentB = 0b0000010,
    SegmentC = 0b0000100,
    SegmentD = 0b0001000,
    SegmentE = 0b0010000,
    SegmentF = 0b0100000,
    SegmentG = 0b1000000,
};

enum State : uint8_t {
    STATE_INIT = 0,
    STATE_AUTO = 1,
    STATE_SWITCH = 2,
    STATE_BIT = 3,
    STATE_RESET_WAIT = 4,
};

TEST_CASE_METHOD(Fixture, "state-machine: Initial state", "[project-05a]")
{
    REQUIRE(core.o_Segments == SegmentA);
    REQUIRE(core.o_State == STATE_INIT);
}

TEST_CASE_METHOD(Fixture, "state-machine: No switches stay in INIT", "[project-05a]")
{
    bench.tick(50);

    ChangeVector8 expected;
    REQUIRE(state.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "state-machine: Switch 1 half press stays INIT", "[project-05a]")
{
    switches.addInputs({{2, Switch1}});

    bench.tick(20);

    ChangeVector8 expected;
    REQUIRE(state.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "state-machine: Switch 1 full press transitions to AUTO", "[project-05a]")
{
    switches.addInputs({{2, Switch1}, {10, 0}});

    bench.tick(20);

    ChangeVector8 expected({{10, STATE_AUTO}});
    REQUIRE(state.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "state-machine: Switch 2 half press stays INIT", "[project-05a]")
{
    switches.addInputs({{2, Switch2}});

    bench.tick(20);

    ChangeVector8 expected;
    REQUIRE(state.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "state-machine: Switch 2 full press transitions to SWITCH", "[project-05a]")
{
    switches.addInputs({{2, Switch2}, {10, 0}});

    bench.tick(20);

    ChangeVector8 expected({{10, STATE_SWITCH}});
    REQUIRE(state.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "state-machine: Switch 3 half press stays INIT", "[project-05a]")
{
    switches.addInputs({{2, Switch3}});

    bench.tick(20);

    ChangeVector8 expected;
    REQUIRE(state.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "state-machine: Switch 3 full press transitions to SWITCH", "[project-05a]")
{
    switches.addInputs({{2, Switch3}, {10, 0}});

    bench.tick(20);

    ChangeVector8 expected({{10, STATE_BIT}});
    REQUIRE(state.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "state-machine: IDLE animates 7Sd", "[project-05a]")
{
    bench.tick(100);

    ChangeVector8 expected({
        {10, SegmentB}, {20, SegmentC}, {30, SegmentD}, {40, SegmentE},
        {50, SegmentF}, {60, SegmentA}, {70, SegmentB}, {80, SegmentC},
        {90, SegmentD}, {100, SegmentE},
    });
    ChangeVector8 empty;
    REQUIRE(segments.changes() == expected);
    REQUIRE(state.changes() == empty);
}

TEST_CASE_METHOD(Fixture, "state-machine: Switches don't change state in AUTO", "[project-05a]")
{
    switches.addInputs({
        {2, Switch1}, {10, 0},
        {11, Switch1}, {12, Switch1 | Switch2}, {13, Switch1 | Switch2 | Switch3},
        {14, Switch1 | Switch2 | Switch3| Switch4}, {25, 0},
        });

    bench.tick(30);

    ChangeVector8 expected({{10, STATE_AUTO}});
    REQUIRE(state.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "state-machine: Switch 4 not long enough to INIT", "[project-05a]")
{
    switches.addInputs({
        {2, Switch1}, {10, 0},
        {12, Switch4}, {23, 0},
    });

    bench.tick(30);

    ChangeVector8 expectedState({{10, STATE_AUTO}});
    REQUIRE(state.changes() == expectedState);

    ChangeVector8 expectedSegments;
    REQUIRE(segments.changes() == expectedSegments);
}

TEST_CASE_METHOD(Fixture, "state-machine: Switch 4 half press transitions to STATE_RESET_WAIT", "[project-05a]")
{
    switches.addInputs({
        {2, Switch1}, {11, 0},
        {12, Switch4},
    });

    bench.tick(30);

    ChangeVector8 expected({{11, STATE_AUTO}, {23, STATE_RESET_WAIT}});
    REQUIRE(state.changes() == expected);
}

TEST_CASE_METHOD(Fixture, "state-machine: Switch 4 full presss transitions to STATE_INIT", "[project-05a]")
{
    switches.addInputs({
        {2, Switch1}, {11, 0},
        {12, Switch4}, {25, 0},
    });

    bench.tick(40);

    ChangeVector8 expectedState({{11, STATE_AUTO}, {23, STATE_RESET_WAIT}, {25, STATE_INIT}});
    REQUIRE(state.changes() == expectedState);

    ChangeVector8 expectedSegments({
        {10, SegmentB}, {25, SegmentA}, {35, SegmentB},
    });
    REQUIRE(segments.changes() == expectedSegments);
}
