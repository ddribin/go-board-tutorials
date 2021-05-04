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
    SignalObserver8 displayOn;
    SignalObserver16 hpos;
    SignalObserver16 vpos;
    VideoSyncGeneratorFixture() :
        core(bench.core()),
        hsync(&UUT::o_hsync),
        hblank(&UUT::o_hblank),
        vsync(&UUT::o_vsync),
        vblank(&UUT::o_vblank),
        displayOn(&UUT::o_display_on),
        hpos(&UUT::o_hpos),
        vpos(&UUT::o_vpos)
    {
        bench.addOutput(hsync);
        bench.addOutput(hblank);
        bench.addOutput(vsync);
        bench.addOutput(vblank);
        bench.addOutput(displayOn);
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
    REQUIRE(core.o_display_on == 1);
    REQUIRE(core.o_hpos == 0);
    REQUIRE(core.o_vpos == 0);
}

TEST_CASE_METHOD(Fixture, "One line", "[project-09a]")
{
    bench.openTrace("/tmp/one-line.vcd");
    bench.tick(22);

    CHECK(hsync.changes() == ChangeVector8({{13, 1}, {17, 0}}));
    CHECK(hblank.changes() == ChangeVector8({{10, 1}, {20, 0}}));
    CHECK(displayOn.changes() == ChangeVector8({{10, 0}, {20, 1}}));
}

TEST_CASE_METHOD(Fixture, "Two lines", "[project-09a]")
{
    bench.openTrace("/tmp/two-lines.vcd");
    bench.tick(42);

    CHECK(hsync.changes() == ChangeVector8({
        {13, 1}, {17, 0},
        {33, 1}, {37, 0},
    }));
    CHECK(hblank.changes() == ChangeVector8({
        {10, 1}, {20, 0},
        {30, 1}, {40, 0},
    }));
    CHECK(displayOn.changes() == ChangeVector8({
        {10, 0}, {20, 1},
        {30, 0}, {40, 1},
    }));
}

