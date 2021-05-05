#include "test-common.hpp"
#include "VUART_Transmitter_tb.h"

struct VUART_Transmitter_Adapter : public VUART_Transmitter_tb
{
    void setClock(uint64_t clock) { i_clk = clock; }
};

using UUT = VUART_Transmitter_Adapter;

struct UARTTransmitterFixture : BaseFixture<UUT> {
    SignalPublisher8 transmitByte;
    SignalPublisher8 transmitValid;
    SignalObserver8 transmitSerial;
    SignalObserver8 transmitActive;
    SignalObserver8 transmitDone;
    UARTTransmitterFixture() :
        transmitByte(&UUT::i_tx_byte, bench),
        transmitValid(&UUT::i_tx_dv, bench),
        transmitSerial(&UUT::o_tx_serial, bench),
        transmitActive(&UUT::o_tx_active, bench),
        transmitDone(&UUT::o_tx_done, bench)
    {
    }
};

using Fixture = UARTTransmitterFixture;

TEST_CASE_METHOD(Fixture, "Initial state", "[project-08a]")
{
    REQUIRE(core.o_tx_active == 0);
    REQUIRE(core.o_tx_done == 0);
}

TEST_CASE_METHOD(Fixture, "Transmit 1 byte", "[project-08a]")
{
    bench.openTrace("/tmp/tx-1-byte.vcd");
    // Send 0x37 = 0011 0111
    transmitByte.addInputs({{10, 0x37}, {11, 0x00}});
    transmitValid.addInputs({{10, 1}, {11, 0}});

    bench.tick(150);

    ChangeVector8 expectedActive({{10, 1}, {110, 0}});
    CHECK(transmitActive.changes() == expectedActive);

    ChangeVector8 expectedDone({{109, 1}, {110, 0}});
    CHECK(transmitDone.changes() == expectedDone);

    ChangeVector8 expectedSerial({
        {1,   1},   // Initial pull-up
        {10,  0},   // Start bit
        {20,  1},   // Bit 0
    //  {30,  1},   // Bit 1
    //  {40,  1},   // Bit 2
        {50,  0},   // Bit 3
        {60,  1},   // Bit 4
    //  {70,  1},   // Bit 5
        {80,  0},   // Bit 6
    //  {90,  0},   // Bit 7
        {100, 1},   // Stop bit
    });
    CHECK(transmitSerial.changes() == expectedSerial);
}

TEST_CASE_METHOD(Fixture, "Transmit 2 bytes with delay", "[project-08a]")
{
    bench.openTrace("/tmp/tx-2-delay.vcd");
    // Send 0x37 = 0011 0111
    transmitByte.addInputs({{10, 0x37}, {11, 0x00}});
    transmitValid.addInputs({{10, 1}, {11, 0}});
    // Send 0x90 = 1001 0000
    transmitByte.addInputs({{210, 0x90}, {211, 0x00}});
    transmitValid.addInputs({{210, 1}, {211, 0}});

    bench.tick(350);

    ChangeVector8 expectedActive({
        {10,  1}, {110, 0},
        {210, 1}, {310, 0},
    });
    CHECK(transmitActive.changes() == expectedActive);

    ChangeVector8 expectedDone({
        {109, 1}, {110, 0},
        {309, 1}, {310, 0},
    });
    CHECK(transmitDone.changes() == expectedDone);

    ChangeVector8 expectedSerial({
        {1,   1},   // Initial pull-up
        // Byte 1
        {10,  0},   // Start bit
        {20,  1},   // Bit 0
    //  {30,  1},   // Bit 1
    //  {40,  1},   // Bit 2
        {50,  0},   // Bit 3
        {60,  1},   // Bit 4
    //  {70,  1},   // Bit 5
        {80,  0},   // Bit 6
    //  {90,  0},   // Bit 7
        {100, 1},   // Stop bit
        // Byte 2
        {210, 0},   // Start bit
    //  {220, 0},   // Bit 0
    //  {230, 0},   // Bit 1
    //  {240, 0},   // Bit 2
    //  {250, 0},   // Bit 3
        {260, 1},   // Bit 4
        {270, 0},   // Bit 5
    //  {280, 0},   // Bit 6
        {290, 1},   // Bit 7
    //  {300, 1},   // Stop bit
    });
    CHECK(transmitSerial.changes() == expectedSerial);
}

TEST_CASE_METHOD(Fixture, "Transmit 2 bytes back-to-back", "[project-08a]")
{
    bench.openTrace("/tmp/tx-2-back-to-back.vcd");
    // Send 0x37 = 0011 0111
    transmitByte.addInputs({{10, 0x37}, {11, 0x00}});
    transmitValid.addInputs({{10, 1}, {11, 0}});
    // Send 0x90 = 1001 0000
    transmitByte.addInputs({{110, 0x90}, {111, 0x00}});
    transmitValid.addInputs({{110, 1}, {111, 0}});

    bench.tick(250);

    ChangeVector8 expectedActive({
        {10,  1}, {210, 0},
    });
    CHECK(transmitActive.changes() == expectedActive);

    ChangeVector8 expectedDone({
        {109, 1}, {110, 0},
        {209, 1}, {210, 0},
    });
    CHECK(transmitDone.changes() == expectedDone);

    ChangeVector8 expectedSerial({
        {1,   1},   // Initial pull-up
        // Byte 1
        {10,  0},   // Start bit
        {20,  1},   // Bit 0
    //  {30,  1},   // Bit 1
    //  {40,  1},   // Bit 2
        {50,  0},   // Bit 3
        {60,  1},   // Bit 4
    //  {70,  1},   // Bit 5
        {80,  0},   // Bit 6
    //  {90,  0},   // Bit 7
        {100, 1},   // Stop bit
        // Byte 2
        {110, 0},   // Start bit
    //  {120, 0},   // Bit 0
    //  {130, 0},   // Bit 1
    //  {140, 0},   // Bit 2
    //  {150, 0},   // Bit 3
        {160, 1},   // Bit 4
        {170, 0},   // Bit 5
    //  {180, 0},   // Bit 6
        {190, 1},   // Bit 7
    //  {200, 1},   // Stop bit
    });
    CHECK(transmitSerial.changes() == expectedSerial);
}