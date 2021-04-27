#include "test-common.hpp"
#include "VFIFO.h"

struct VFIFO_Adapter : public VFIFO
{
    void setClock(uint64_t clock) { i_clk = clock; }
};

using UUT = VFIFO_Adapter;

struct FIFOFixture {
    using SignalPublisher8 = SignalPublisher<uint8_t, UUT>;
    using SignalObserver8 = SignalObserver<uint8_t, UUT>;
    TestBench<UUT> bench;
    UUT& core;
    SignalPublisher8 writeEnable;
    SignalPublisher8 writeData;
    SignalPublisher8 readEnable;
    SignalObserver8 readData;
    SignalObserver8 fifoNotEmpty;
    FIFOFixture() :
        core(bench.core()),
        writeEnable(&UUT::i_wr_en),
        writeData(&UUT::i_wr_data),
        readEnable(&UUT::i_rd_en),
        readData(&UUT::o_rd_data),
        fifoNotEmpty(&UUT::o_fifo_not_empty)
    {
        bench.addInput(writeEnable);
        bench.addInput(writeData);
        bench.addInput(readEnable);
        bench.addOutput(readData);
        bench.addOutput(fifoNotEmpty);
    };
};

using Fixture = FIFOFixture;

TEST_CASE_METHOD(Fixture, "FIFO: Initial state", "[project-08a]")
{
    REQUIRE(core.o_rd_data == 0);
    REQUIRE(core.o_fifo_not_empty == 0);
}

TEST_CASE_METHOD(Fixture, "FIFO: Write data is immediately availble", "[project-8a]")
{
    writeEnable.addInputs({{1, 1}, {2, 0}});
    writeData.addInputs({{1, 0x37}});

    bench.tick(10);

    REQUIRE(fifoNotEmpty.changes() == ChangeVector8({{1, 1}}));

    REQUIRE(readData.changes() == ChangeVector8({{1, 0x37}}));
}

TEST_CASE_METHOD(Fixture, "FIFO: Write data is read later", "[project-8a]")
{
    bench.openTrace("/tmp/wr-rd-later.vcd");
    writeEnable.addInputs({{1, 1}, {2, 0}});
    writeData.addInputs({{1, 0x37}});
    readEnable.addInputs({{5, 1}, {6, 0}});

    bench.tick(10);

    REQUIRE(fifoNotEmpty.changes() == ChangeVector8({{1, 1}, {5, 0}}));

    REQUIRE(readData.changes() == ChangeVector8({{1, 0x37}}));
}

TEST_CASE_METHOD(Fixture, "FIFO: Write data is read on same clock", "[project-8a]")
{
    bench.openTrace("/tmp/wr-rd-same.vcd");
    writeEnable.addInputs({{1, 1}, {2, 0}});
    writeData.addInputs({{1, 0x37}});
    readEnable.addInputs({{1, 1}, {2, 0}});

    bench.tick(10);

    REQUIRE(fifoNotEmpty.changes() == ChangeVector8({{1, 1}, {2, 0}}));

    REQUIRE(readData.changes() == ChangeVector8({{1, 0x37}}));
}

TEST_CASE_METHOD(Fixture, "FIFO: Write data is read on next clock", "[project-8a]")
{
    bench.openTrace("/tmp/wr-rd-next.vcd");
    writeEnable.addInputs({{1, 1}, {2, 0}});
    writeData.addInputs({{1, 0x37}});
    readEnable.addInputs({{2, 1}, {3, 0}});

    bench.tick(10);

    REQUIRE(fifoNotEmpty.changes() == ChangeVector8({{1, 1}, {2, 0}}));

    REQUIRE(readData.changes() == ChangeVector8({{1, 0x37}}));
}

TEST_CASE_METHOD(Fixture, "FIFO: Write data is read +2", "[project-8a]")
{
    bench.openTrace("/tmp/wr-rd-plus-two.vcd");
    writeEnable.addInputs({{1, 1}, {2, 0}});
    writeData.addInputs({{1, 0x37}});
    readEnable.addInputs({{3, 1}, {4, 0}});

    bench.tick(10);

    REQUIRE(fifoNotEmpty.changes() == ChangeVector8({{1, 1}, {3, 0}}));

    REQUIRE(readData.changes() == ChangeVector8({{1, 0x37}}));
}
