#include "test-common.hpp"
#include "VFIFO_2word_FWFT.h"

struct VFIFO_2word_FWFT_Adapter : public VFIFO_2word_FWFT
{
    void setClock(uint64_t clock) { clk = clock; }
};

using UUT = VFIFO_2word_FWFT_Adapter;

struct FIFOFWFTFixture {
    using SignalPublisher8 = SignalPublisher<uint8_t, UUT>;
    using SignalObserver8 = SignalObserver<uint8_t, UUT>;
    TestBench<UUT> bench;
    UUT& core;
    SignalPublisher8 writeEnable;
    SignalPublisher8 writeData;
    SignalPublisher8 readEnable;
    SignalObserver8 readData;
    SignalObserver8 fifoNotEmpty;
    FIFOFWFTFixture() :
        core(bench.core()),
        writeEnable(&UUT::shift_in),
        writeData(&UUT::data_in),
        readEnable(&UUT::shift_out),
        readData(&UUT::data_out),
        fifoNotEmpty(&UUT::fifo_not_empty)
    {
        bench.addInput(writeEnable);
        bench.addInput(writeData);
        bench.addInput(readEnable);
        bench.addOutput(readData);
        bench.addOutput(fifoNotEmpty);
    };
};

using Fixture = FIFOFWFTFixture;

TEST_CASE_METHOD(Fixture, "FIFOFWFT: Initial state", "[project-08a]")
{
    REQUIRE(core.data_out == 0);
    REQUIRE(core.fifo_not_empty == 0);
}

TEST_CASE_METHOD(Fixture, "FIFOFWFT: Write data is immediately availble", "[project-8a]")
{
    writeEnable.addInputs({{1, 1}, {2, 0}});
    writeData.addInputs({{1, 0x37}});

    bench.tick(10);

    REQUIRE(fifoNotEmpty.changes() == ChangeVector8({{1, 1}}));

    REQUIRE(readData.changes() == ChangeVector8({{1, 0x37}}));
}

TEST_CASE_METHOD(Fixture, "FIFOFWFT: Write data is read later", "[project-8a]")
{
    bench.openTrace("/tmp/fwft-wr-rd-later.vcd");
    writeEnable.addInputs({{1, 1}, {2, 0}});
    writeData.addInputs({{1, 0x37}});
    readEnable.addInputs({{5, 1}, {6, 0}});

    bench.tick(10);

    REQUIRE(fifoNotEmpty.changes() == ChangeVector8({{1, 1}, {5, 0}}));

    REQUIRE(readData.changes() == ChangeVector8({{1, 0x37}, {5, 0}}));
}

TEST_CASE_METHOD(Fixture, "FIFOFWFT: Write data is read on same clock", "[project-8a]")
{
    bench.openTrace("/tmp/fwft-wr-rd-same.vcd");
    writeEnable.addInputs({{1, 1}, {2, 0}});
    writeData.addInputs({{1, 0x37}});
    readEnable.addInputs({{1, 1}, {2, 0}});

    bench.tick(10);

    REQUIRE(fifoNotEmpty.changes() == ChangeVector8({{1, 1}}));

    REQUIRE(readData.changes() == ChangeVector8({{1, 0x37}}));
}

TEST_CASE_METHOD(Fixture, "FIFOFWFT: Write data is read on next clock", "[project-8a]")
{
    bench.openTrace("/tmp/fwft-wr-rd-next.vcd");
    writeEnable.addInputs({{1, 1}, {2, 0}});
    writeData.addInputs({{1, 0x37}});
    readEnable.addInputs({{2, 1}, {3, 0}});

    bench.tick(10);

    REQUIRE(fifoNotEmpty.changes() == ChangeVector8({{1, 1}, {2, 0}}));

    REQUIRE(readData.changes() == ChangeVector8({{1, 0x37}, {2, 0}}));
}