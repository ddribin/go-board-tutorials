#include "test-common.hpp"
#include "VUART_Receiver_tb.h"

struct VUART_Receiver_Adapter : public VUART_Receiver_tb
{
    void setClock(uint64_t clock) { i_clk = clock; }
};

using UUT = VUART_Receiver_Adapter;

struct UARTReceiveFixture {
    using SignalPublisher8 = SignalPublisher<uint8_t, UUT>;
    using SignalObserver8 = SignalObserver<uint8_t, UUT>;
    TestBench<UUT> bench;
    UUT& core;
    SignalPublisher8 serialRx;
    SignalObserver8 receiveValid;
    SignalObserver8 receiveByte;
    UARTReceiveFixture() :
        core(bench.core()),
        serialRx(&UUT::i_serial_rx),
        receiveValid(&UUT::o_rx_valid),
        receiveByte(&UUT::o_rx_byte)
    {
        bench.addInput(serialRx);
        bench.addOutput(receiveValid);
        bench.addOutput(receiveByte);
        core.i_serial_rx = 1;
    };
};

using Fixture = UARTReceiveFixture;

TEST_CASE_METHOD(Fixture, "Initial state", "[project-07a]")
{
    REQUIRE(core.o_rx_valid == 0);
    REQUIRE(core.o_rx_byte == 0);
}

TEST_CASE_METHOD(Fixture, "Receive 1 byte", "[project-07a]")
{
    // Send 0x37 = 0011 0111
    serialRx.addInputs({
        {10,  0},   // Start bit
        {20,  1},   // Bit 0
        {30,  1},   // Bit 1
        {40,  1},   // Bit 2
        {50,  0},   // Bit 3
        {60,  1},   // Bit 4
        {70,  1},   // Bit 5
        {80,  0},   // Bit 6
        {90,  0},   // Bit 7
        {100, 1},   // Stop bit
    });

    bench.tick(150);

    ChangeVector8 expectedValid({{105, 1}, {106, 0}});
    CHECK(receiveValid.changes() == expectedValid);

    ChangeVector8 expectedByte({
    //  {15,  0b00000000},
        {25,  0b10000000},
        {35,  0b11000000},
        {45,  0b11100000},
        {55,  0b01110000},
        {65,  0b10111000},
        {75,  0b11011100},
        {85,  0b01101110},
        {95,  0b00110111},
    });
    CHECK(receiveByte.changes() == expectedByte);
}

TEST_CASE_METHOD(Fixture, "Receive 2 bytes with delay", "[project-07a]")
{
    // Send 0x37 = 0011 0111
    serialRx.addInputs({
        {10,  0},   // Start bit
        {20,  1},   // Bit 0
        {30,  1},   // Bit 1
        {40,  1},   // Bit 2
        {50,  0},   // Bit 3
        {60,  1},   // Bit 4
        {70,  1},   // Bit 5
        {80,  0},   // Bit 6
        {90,  0},   // Bit 7
        {100, 1},   // Stop bit
    });

    // Send 0x90 = 1001 0000
    serialRx.addInputs({
        {210, 0},   // Start bit
        {220, 0},   // Bit 0
        {230, 0},   // Bit 1
        {240, 0},   // Bit 2
        {250, 0},   // Bit 3
        {260, 1},   // Bit 4
        {270, 0},   // Bit 5
        {290, 1},   // Bit 7
        {300, 1},   // Stop bit
    });

    bench.tick(350);

    ChangeVector8 expectedValid({
        {105, 1}, {106, 0},
        {305, 1}, {306, 0},
    });
    CHECK(receiveValid.changes() == expectedValid);

    ChangeVector8 expectedByte({
    //  {15,  0b00000000},
        {25,  0b10000000},
        {35,  0b11000000},
        {45,  0b11100000},
        {55,  0b01110000},
        {65,  0b10111000},
        {75,  0b11011100},
        {85,  0b01101110},
        {95,  0b00110111},
        {210, 0},
    //  {225, 0b00000000},
    //  {235, 0b00000000},
    //  {245, 0b00000000},
    //  {255, 0b00000000},
        {265, 0b10000000},
        {275, 0b01000000},
        {285, 0b00100000},
        {295, 0b10010000},
    });
    CHECK(receiveByte.changes() == expectedByte);
}

TEST_CASE_METHOD(Fixture, "Receive 2 bytes back to back", "[project-07a]")
{
    // Send 0x37 = 0011 0111
    serialRx.addInputs({
        {10,  0},   // Start bit
        {20,  1},   // Bit 0
        {30,  1},   // Bit 1
        {40,  1},   // Bit 2
        {50,  0},   // Bit 3
        {60,  1},   // Bit 4
        {70,  1},   // Bit 5
        {80,  0},   // Bit 6
        {90,  0},   // Bit 7
        {100, 1},   // Stop bit
    });

    // Send 0x90 = 1001 0000
    serialRx.addInputs({
        {110, 0},   // Start bit
        {120, 0},   // Bit 0
        {130, 0},   // Bit 1
        {140, 0},   // Bit 2
        {150, 0},   // Bit 3
        {160, 1},   // Bit 4
        {170, 0},   // Bit 5
        {190, 1},   // Bit 7
        {200, 1},   // Stop bit
    });

    bench.tick(250);

    ChangeVector8 expectedValid({
        {105, 1}, {106, 0},
        {205, 1}, {206, 0},
    });
    CHECK(receiveValid.changes() == expectedValid);

    ChangeVector8 expectedByte({
        {25,  0b10000000},
        {35,  0b11000000},
        {45,  0b11100000},
        {55,  0b01110000},
        {65,  0b10111000},
        {75,  0b11011100},
        {85,  0b01101110},
        {95,  0b00110111},
        {110, 0},
    //  {125, 0b00000000},
    //  {135, 0b00000000},
    //  {145, 0b00000000},
    //  {155, 0b00000000},
        {165, 0b10000000},
        {175, 0b01000000},
        {185, 0b00100000},
        {195, 0b10010000},
    });
    CHECK(receiveByte.changes() == expectedByte);
}

TEST_CASE_METHOD(Fixture, "Glitched start bit restarts state machine", "[project-07a]")
{
    // Send 0x37 = 0011 0111
    serialRx.addInputs({
        {10,  0},   // Glitched start bit for 2 cycles
        {12,  1},
        {20,  0},   // Real start bit
        {30,  1},   // Bit 0
        {40,  1},   // Bit 1
        {50,  1},   // Bit 2
        {60,  0},   // Bit 3
        {70,  1},   // Bit 4
        {80,  1},   // Bit 5
        {90,  0},   // Bit 6
        {100, 0},   // Bit 7
        {110, 1},   // Stop bit
    });

    bench.tick(150);

    ChangeVector8 expectedValid({{115, 1}, {116, 0}});
    CHECK(receiveValid.changes() == expectedValid);

    ChangeVector8 expectedByte({
        {35,  0b10000000},
        {45,  0b11000000},
        {55,  0b11100000},
        {65,  0b01110000},
        {75,  0b10111000},
        {85,  0b11011100},
        {95,  0b01101110},
        {105, 0b00110111},
    });
    CHECK(receiveByte.changes() == expectedByte);
}

TEST_CASE_METHOD(Fixture, "Glitched stop bit restarts state machine", "[project-07a]")
{
    // Send 0x37 = 0011 0111
    serialRx.addInputs({
        {10,  0},   // Start bit
        {20,  1},   // Bit 0
        {30,  1},   // Bit 1
        {40,  1},   // Bit 2
        {50,  0},   // Bit 3
        {60,  1},   // Bit 4
        {70,  1},   // Bit 5
        {80,  0},   // Bit 6
        {90,  0},   // Bit 7
        {100, 1},   // Glitched stop bit
        {102, 0},
        {108, 1},
    });

    // Send 0x90 = 1001 0000
    serialRx.addInputs({
        {110, 0},   // Start bit
        {120, 0},   // Bit 0
        {130, 0},   // Bit 1
        {140, 0},   // Bit 2
        {150, 0},   // Bit 3
        {160, 1},   // Bit 4
        {170, 0},   // Bit 5
        {190, 1},   // Bit 7
        {200, 1},   // Stop bit
    });

    bench.tick(250);

    ChangeVector8 expectedValid({
        {205, 1}, {206, 0},
    });
    CHECK(receiveValid.changes() == expectedValid);

    ChangeVector8 expectedByte({
        {25,  0b10000000},
        {35,  0b11000000},
        {45,  0b11100000},
        {55,  0b01110000},
        {65,  0b10111000},
        {75,  0b11011100},
        {85,  0b01101110},
        {95,  0b00110111},
        {110, 0},
    //  {125, 0b00000000},
    //  {135, 0b00000000},
    //  {145, 0b00000000},
    //  {155, 0b00000000},
        {165, 0b10000000},
        {175, 0b01000000},
        {185, 0b00100000},
        {195, 0b10010000},
    });
    CHECK(receiveByte.changes() == expectedByte);

}