#include "test-common.hpp"
#include "VNibble_To_7SD.h"

struct VNibble_To_7SD_Adapter : public VNibble_To_7SD
{
    void setClock(uint64_t clock) { i_Clk = clock; }
};

using UUT = VNibble_To_7SD_Adapter;

struct NibbleTo7SDFixture {
    using SignalPublisher8 = SignalPublisher<uint8_t, UUT>;
    using SignalObserver8 = SignalObserver<uint8_t, UUT>;
    TestBench<UUT> bench;
    UUT& core;
    SignalPublisher8 nibble;
    SignalObserver8 segment_a;
    SignalObserver8 segment_b;
    SignalObserver8 segment_c;
    SignalObserver8 segment_d;
    SignalObserver8 segment_e;
    SignalObserver8 segment_f;
    SignalObserver8 segment_g;

    NibbleTo7SDFixture() :
        core(bench.core()),
        nibble(&UUT::i_Nibble),
        segment_a(&UUT::o_Segment_A),
        segment_b(&UUT::o_Segment_B),
        segment_c(&UUT::o_Segment_C),
        segment_d(&UUT::o_Segment_D),
        segment_e(&UUT::o_Segment_E),
        segment_f(&UUT::o_Segment_F),
        segment_g(&UUT::o_Segment_G)
    {
        bench.addInput(nibble);
        bench.addOutput(segment_a);
        bench.addOutput(segment_b);
        bench.addOutput(segment_c);
        bench.addOutput(segment_d);
        bench.addOutput(segment_e);
        bench.addOutput(segment_f);
        bench.addOutput(segment_g);
    }
};

using Fixture = NibbleTo7SDFixture;

static const ChangeVector8 OFF;
static const ChangeVector8 ON{{1, 1}};

/*
 +-A-+
 |   |
 F   B
 |   |
 +-G-+
 |   |
 E   C
 |   |
 +-D-+
*/

TEST_CASE_METHOD(Fixture, "Digit 0", "[project-05a]")
{
    //  _ 
    // | |
    // |_|    
    nibble.addInputs({{1, 0x0}});

    bench.tick(2);

    CHECK(segment_a.changes() == ON);
    CHECK(segment_b.changes() == ON);
    CHECK(segment_c.changes() == ON);
    CHECK(segment_d.changes() == ON);
    CHECK(segment_e.changes() == ON);
    CHECK(segment_f.changes() == ON);
    CHECK(segment_g.changes() == OFF);
}

TEST_CASE_METHOD(Fixture, "Digit 1", "[project-05a]")
{
    //   
    //  |
    //  |
    nibble.addInputs({{1, 0x1}});

    bench.tick(2);

    CHECK(segment_a.changes() == OFF);
    CHECK(segment_b.changes() == ON);
    CHECK(segment_c.changes() == ON);
    CHECK(segment_d.changes() == OFF);
    CHECK(segment_e.changes() == OFF);
    CHECK(segment_f.changes() == OFF);
    CHECK(segment_g.changes() == OFF);
}

TEST_CASE_METHOD(Fixture, "Digit 2", "[project-05a]")
{
    //  _ 
    //  _|
    // |_ 
    nibble.addInputs({{1, 0x2}});

    bench.tick(2);

    CHECK(segment_a.changes() == ON);
    CHECK(segment_b.changes() == ON);
    CHECK(segment_c.changes() == OFF);
    CHECK(segment_d.changes() == ON);
    CHECK(segment_e.changes() == ON);
    CHECK(segment_f.changes() == OFF);
    CHECK(segment_g.changes() == ON);
}

TEST_CASE_METHOD(Fixture, "Digit 3", "[project-05a]")
{
    //  _ 
    //  _|
    //  _|
    nibble.addInputs({{1, 0x3}});

    bench.tick(2);

    CHECK(segment_a.changes() == ON);
    CHECK(segment_b.changes() == ON);
    CHECK(segment_c.changes() == ON);
    CHECK(segment_d.changes() == ON);
    CHECK(segment_e.changes() == OFF);
    CHECK(segment_f.changes() == OFF);
    CHECK(segment_g.changes() == ON);
}

TEST_CASE_METHOD(Fixture, "Digit 4", "[project-05a]")
{
    //    
    // |_|
    //   |
    nibble.addInputs({{1, 0x4}});

    bench.tick(2);

    CHECK(segment_a.changes() == OFF);
    CHECK(segment_b.changes() == ON);
    CHECK(segment_c.changes() == ON);
    CHECK(segment_d.changes() == OFF);
    CHECK(segment_e.changes() == OFF);
    CHECK(segment_f.changes() == ON);
    CHECK(segment_g.changes() == ON);
}

TEST_CASE_METHOD(Fixture, "Digit 5", "[project-05a]")
{
    //  _ 
    // |_ 
    //  _|
    nibble.addInputs({{1, 0x5}});

    bench.tick(2);

    CHECK(segment_a.changes() == ON);
    CHECK(segment_b.changes() == OFF);
    CHECK(segment_c.changes() == ON);
    CHECK(segment_d.changes() == ON);
    CHECK(segment_e.changes() == OFF);
    CHECK(segment_f.changes() == ON);
    CHECK(segment_g.changes() == ON);
}

TEST_CASE_METHOD(Fixture, "Digit 6", "[project-05a]")
{
    //  _ 
    // |_ 
    // |_|
    nibble.addInputs({{1, 0x6}});

    bench.tick(2);

    CHECK(segment_a.changes() == ON);
    CHECK(segment_b.changes() == OFF);
    CHECK(segment_c.changes() == ON);
    CHECK(segment_d.changes() == ON);
    CHECK(segment_e.changes() == ON);
    CHECK(segment_f.changes() == ON);
    CHECK(segment_g.changes() == ON);

}

TEST_CASE_METHOD(Fixture, "Digit 7", "[project-05a]")
{
    //  _ 
    //   |
    //   |
    nibble.addInputs({{1, 0x7}});

    bench.tick(2);

    CHECK(segment_a.changes() == ON);
    CHECK(segment_b.changes() == ON);
    CHECK(segment_c.changes() == ON);
    CHECK(segment_d.changes() == OFF);
    CHECK(segment_e.changes() == OFF);
    CHECK(segment_f.changes() == OFF);
    CHECK(segment_g.changes() == OFF);

}

TEST_CASE_METHOD(Fixture, "Digit 8", "[project-05a]")
{
    //  _ 
    // |_|
    // |_|
    nibble.addInputs({{1, 0x8}});

    bench.tick(2);

    CHECK(segment_a.changes() == ON);
    CHECK(segment_b.changes() == ON);
    CHECK(segment_c.changes() == ON);
    CHECK(segment_d.changes() == ON);
    CHECK(segment_e.changes() == ON);
    CHECK(segment_f.changes() == ON);
    CHECK(segment_g.changes() == ON);
}

TEST_CASE_METHOD(Fixture, "Digit 9", "[project-05a]")
{
    //  _
    // |_|
    //  _|
    nibble.addInputs({{1, 0x9}});

    bench.tick(2);

    CHECK(segment_a.changes() == ON);
    CHECK(segment_b.changes() == ON);
    CHECK(segment_c.changes() == ON);
    CHECK(segment_d.changes() == ON);
    CHECK(segment_e.changes() == OFF);
    CHECK(segment_f.changes() == ON);
    CHECK(segment_g.changes() == ON);
}

TEST_CASE_METHOD(Fixture, "Digit A", "[project-05a]")
{
    //  _ 
    // |_|
    // | |
    nibble.addInputs({{1, 0xA}});

    bench.tick(2);

    CHECK(segment_a.changes() == ON);
    CHECK(segment_b.changes() == ON);
    CHECK(segment_c.changes() == ON);
    CHECK(segment_d.changes() == OFF);
    CHECK(segment_e.changes() == ON);
    CHECK(segment_f.changes() == ON);
    CHECK(segment_g.changes() == ON);
}

TEST_CASE_METHOD(Fixture, "Digit B", "[project-05a]")
{
    //    
    // |_ 
    // |_|
    nibble.addInputs({{1, 0xB}});

    bench.tick(2);

    CHECK(segment_a.changes() == OFF);
    CHECK(segment_b.changes() == OFF);
    CHECK(segment_c.changes() == ON);
    CHECK(segment_d.changes() == ON);
    CHECK(segment_e.changes() == ON);
    CHECK(segment_f.changes() == ON);
    CHECK(segment_g.changes() == ON);
}

TEST_CASE_METHOD(Fixture, "Digit C", "[project-05a]")
{
    //  _ 
    // |  
    // |_ 
    nibble.addInputs({{1, 0xC}});

    bench.tick(2);

    CHECK(segment_a.changes() == ON);
    CHECK(segment_b.changes() == OFF);
    CHECK(segment_c.changes() == OFF);
    CHECK(segment_d.changes() == ON);
    CHECK(segment_e.changes() == ON);
    CHECK(segment_f.changes() == ON);
    CHECK(segment_g.changes() == OFF);
}

TEST_CASE_METHOD(Fixture, "Digit D", "[project-05a]")
{
    //    
    //  _|
    // |_|
    nibble.addInputs({{1, 0xD}});

    bench.tick(2);

    CHECK(segment_a.changes() == OFF);
    CHECK(segment_b.changes() == ON);
    CHECK(segment_c.changes() == ON);
    CHECK(segment_d.changes() == ON);
    CHECK(segment_e.changes() == ON);
    CHECK(segment_f.changes() == OFF);
    CHECK(segment_g.changes() == ON);
}

TEST_CASE_METHOD(Fixture, "Digit E", "[project-05a]")
{
    //  _ 
    // |_ 
    // |_ 
    nibble.addInputs({{1, 0xE}});

    bench.tick(2);

    CHECK(segment_a.changes() == ON);
    CHECK(segment_b.changes() == OFF);
    CHECK(segment_c.changes() == OFF);
    CHECK(segment_d.changes() == ON);
    CHECK(segment_e.changes() == ON);
    CHECK(segment_f.changes() == ON);
    CHECK(segment_g.changes() == ON);
}

TEST_CASE_METHOD(Fixture, "Digit F", "[project-05a]")
{
    //  _ 
    // |_ 
    // |  
    nibble.addInputs({{1, 0xF}});

    bench.tick(2);

    CHECK(segment_a.changes() == ON);
    CHECK(segment_b.changes() == OFF);
    CHECK(segment_c.changes() == OFF);
    CHECK(segment_d.changes() == OFF);
    CHECK(segment_e.changes() == ON);
    CHECK(segment_f.changes() == ON);
    CHECK(segment_g.changes() == ON);
}
