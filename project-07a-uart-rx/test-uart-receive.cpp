#include "test-common.hpp"
#include "VUART_Receive_tb.h"

struct VUART_Receive_Adapter : public VUART_Receive_tb
{
    void setClock(uint64_t clock) { i_clk = clock; }
};

using UUT = VUART_Receive_Adapter;

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

    ChangeVector8 expectedValid({{105, 1}, {109, 0}});
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
        {109, 0},
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
        {105, 1}, {109, 0},
        {305, 1}, {309, 0},
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
        {109, 0},
    //  {225, 0b00000000},
    //  {235, 0b00000000},
    //  {245, 0b00000000},
    //  {255, 0b00000000},
        {265, 0b10000000},
        {275, 0b01000000},
        {285, 0b00100000},
        {295, 0b10010000},
        {309, 0},
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
        {105, 1}, {109, 0},
        {205, 1}, {209, 0},
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
        {109, 0},
    //  {125, 0b00000000},
    //  {135, 0b00000000},
    //  {145, 0b00000000},
    //  {155, 0b00000000},
        {165, 0b10000000},
        {175, 0b01000000},
        {185, 0b00100000},
        {195, 0b10010000},
        {209, 0},
    });
    CHECK(receiveByte.changes() == expectedByte);
}
