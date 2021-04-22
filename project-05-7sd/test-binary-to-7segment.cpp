#include "test-common.hpp"
#include "VBinary_To_7Segment.h"

struct VBinary_To_7Segment_Adapter : public VBinary_To_7Segment
{
    void setClock(uint64_t clock) { i_Clk = clock; }
};

using UUT = VBinary_To_7Segment_Adapter;

struct BinaryTo7SegmentFixture {
    using SignalPublisher8 = SignalPublisher<uint8_t, UUT>;
    using SignalObserver8 = SignalObserver<uint8_t, UUT>;
    TestBench<UUT> bench;
    UUT& core;
    SignalPublisher8 binaryNum;
    SignalObserver8 segment_a;
    SignalObserver8 segment_b;
    SignalObserver8 segment_c;
    SignalObserver8 segment_d;
    SignalObserver8 segment_e;
    SignalObserver8 segment_f;
    SignalObserver8 segment_g;

    BinaryTo7SegmentFixture() :
        core(bench.core()),
        binaryNum(&UUT::i_Binary_Num),
        segment_a(&UUT::o_Segment_A),
        segment_b(&UUT::o_Segment_B),
        segment_c(&UUT::o_Segment_C),
        segment_d(&UUT::o_Segment_D),
        segment_e(&UUT::o_Segment_E),
        segment_f(&UUT::o_Segment_F),
        segment_g(&UUT::o_Segment_G)
    {
        bench.addInput(binaryNum);
        bench.addOutput(segment_a);
        bench.addOutput(segment_b);
        bench.addOutput(segment_c);
        bench.addOutput(segment_d);
        bench.addOutput(segment_e);
        bench.addOutput(segment_f);
        bench.addOutput(segment_g);
    }
};

using Fixture = BinaryTo7SegmentFixture;

static const ChangeVector8 OFF;
static const ChangeVector8 ON{{1, 1}};

TEST_CASE_METHOD(Fixture, "Digit 0", "[project-05]")
{
    //  _ 
    // | |
    // |_|    
    binaryNum.addInputs({{1, 0x0}});

    bench.tick(2);

    CHECK(segment_a.changes() == ON);
    CHECK(segment_b.changes() == ON);
    CHECK(segment_c.changes() == ON);
    CHECK(segment_d.changes() == ON);
    CHECK(segment_e.changes() == ON);
    CHECK(segment_f.changes() == ON);
    CHECK(segment_g.changes() == OFF);
}
