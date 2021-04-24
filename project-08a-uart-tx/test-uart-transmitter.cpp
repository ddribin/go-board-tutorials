#include "test-common.hpp"
#include "VUART_Transmitter_tb.h"

struct VUART_Transmitter_Adapter : public VUART_Transmitter_tb
{
    void setClock(uint64_t clock) { i_clk = clock; }
};

using UUT = VUART_Transmitter_Adapter;

struct UARTTransmitterFixture {
    using SignalPublisher8 = SignalPublisher<uint8_t, UUT>;
    using SignalObserver8 = SignalObserver<uint8_t, UUT>;
    TestBench<UUT> bench;
    UUT& core;
    SignalPublisher8 transmitByte;
    SignalPublisher8 transmitValid;
    SignalObserver8 transmitSerial;
    SignalObserver8 transmitActive;
    SignalObserver8 transmitDone;
    UARTTransmitterFixture() :
        core(bench.core()),
        transmitByte(&UUT::i_tx_byte),
        transmitValid(&UUT::i_tx_dv),
        transmitSerial(&UUT::o_tx_serial),
        transmitActive(&UUT::o_tx_active),
        transmitDone(&UUT::o_tx_done)
    {
        bench.addInput(transmitByte);
        bench.addInput(transmitValid);
        bench.addOutput(transmitSerial);
        bench.addOutput(transmitActive);
        bench.addOutput(transmitDone);
    };
};

using Fixture = UARTTransmitterFixture;

TEST_CASE_METHOD(Fixture, "Initial state", "[project-08a]")
{
    REQUIRE(core.o_tx_active == 0);
    REQUIRE(core.o_tx_done == 0);
}