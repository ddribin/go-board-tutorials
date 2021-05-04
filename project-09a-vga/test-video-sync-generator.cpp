#include "test-common.hpp"
#include "VVideo_Sync_Generator_tb.h"

struct VVideo_Sync_Generator_Adapter : public VVideo_Sync_Generator_tb
{
    void setClock(uint64_t clock) { i_clk = clock; }
};

using UUT = VVideo_Sync_Generator_Adapter;

struct VideoSyncGeneratorFixture {
    using SignalPublisher8 = SignalPublisher<uint8_t, UUT>;
    using SignalObserver8 = SignalObserver<uint8_t, UUT>;
    using SignalObserver16 = SignalObserver<uint16_t, UUT>;
    TestBench<UUT> bench;
    UUT& core;
    SignalObserver8 hsync;
    SignalObserver8 hblank;
    SignalObserver8 vsync;
    SignalObserver8 vblank;
    SignalObserver8 visible;
    SignalObserver16 hpos;
    SignalObserver16 vpos;
    VideoSyncGeneratorFixture() :
        core(bench.core()),
        hsync(&UUT::o_hsync),
        hblank(&UUT::o_hblank),
        vsync(&UUT::o_vsync),
        vblank(&UUT::o_vblank),
        visible(&UUT::o_visible),
        hpos(&UUT::o_hpos),
        vpos(&UUT::o_vpos)
    {
        bench.addOutput(hsync);
        bench.addOutput(hblank);
        bench.addOutput(vsync);
        bench.addOutput(vblank);
        bench.addOutput(visible);
        bench.addOutput(hpos);
        bench.addOutput(vpos);
    };
};

using Fixture = VideoSyncGeneratorFixture;

TEST_CASE_METHOD(Fixture, "Initial state", "[project-09a]")
{
    REQUIRE(core.o_hsync == 0);
    REQUIRE(core.o_hblank == 0);
    REQUIRE(core.o_vsync == 0);
    REQUIRE(core.o_vblank == 0);
    REQUIRE(core.o_visible == 1);
    REQUIRE(core.o_hpos == 0);
    REQUIRE(core.o_vpos == 0);
}

using SignalEvent16 = SignalEvent<uint16_t>;
using ChangeVector16 = std::vector<SignalEvent16>;

TEST_CASE_METHOD(Fixture, "One line", "[project-09a]")
{
    bench.tick(22);

    CHECK(hsync.changes() == ChangeVector8({{13, 1}, {17, 0}}));
    CHECK(hblank.changes() == ChangeVector8({{10, 1}, {20, 0}}));
    CHECK(visible.changes() == ChangeVector8({{10, 0}, {20, 1}}));
    CHECK(hpos.changes() == ChangeVector16({
        {1, 1}, {2, 2}, {3, 3}, {4, 4}, {5, 5},
        {6, 6}, {7, 7}, {8, 8}, {9, 9}, {10, 10},
        {11, 11}, {12, 12}, {13, 13}, {14, 14}, {15, 15},
        {16, 16}, {17, 17}, {18, 18}, {19, 19}, {20, 0},
        {21, 1}, {22, 2},
    }));
}

TEST_CASE_METHOD(Fixture, "Two lines", "[project-09a]")
{
    bench.tick(42);

    CHECK(hsync.changes() == ChangeVector8({
        {13, 1}, {17, 0},
        {33, 1}, {37, 0},
    }));
    CHECK(hblank.changes() == ChangeVector8({
        {10, 1}, {20, 0},
        {30, 1}, {40, 0},
    }));
    CHECK(visible.changes() == ChangeVector8({
        {10, 0}, {20, 1},
        {30, 0}, {40, 1},
    }));
}

TEST_CASE_METHOD(Fixture, "One frame", "[project-09a]")
{
    bench.openTrace("/tmp/one-frame.vcd");
    bench.tick(20*10+2);

    CHECK(vsync.changes() == ChangeVector8({{120, 1}, {140, 0}}));
    CHECK(vblank.changes() == ChangeVector8({{60, 1}, {200, 0}}));
    CHECK(visible.changes() == ChangeVector8({
        {10, 0},            // Line 0, Frame 0
        {20, 1}, {30, 0},   // Line 1, Frame 0
        {40, 1}, {50, 0},   // Line 2, Frame 0
        {200, 1},           // Line 0, Frame 1
    }));
    CHECK(vpos.changes() == ChangeVector16({
        {20, 1}, {40, 2}, {60, 3}, {80, 4}, {100, 5},
        {120, 6}, {140, 7}, {160, 8}, {180, 9}, {200, 0},
    }));
}

TEST_CASE_METHOD(Fixture, "Two frames", "[project-09a]")
{
    bench.openTrace("/tmp/two-frames.vcd");
    bench.tick(20*20+2);

    CHECK(vsync.changes() == ChangeVector8({
        {120, 1}, {140, 0},
        {320, 1}, {340, 0},
    }));
    CHECK(vblank.changes() == ChangeVector8({
        {60, 1}, {200, 0},
        {260, 1}, {400, 0},
    }));
    CHECK(visible.changes() == ChangeVector8({
        {10, 0},            // Line 0, Frame 0
        {20, 1}, {30, 0},   // Line 1, Frame 0
        {40, 1}, {50, 0},   // Line 2, Frame 0
        {200, 1}, {210, 0}, // Line 0, Frame 1
        {220, 1}, {230, 0}, // Line 1, Frame 1
        {240, 1}, {250, 0}, // Line 2, Frame 1
        {400, 1},           // Line 0, Frame 2
    }));
}
