#if __INTELLISENSE__
#pragma diag_suppress 2486
#endif

#include "TestBench.hpp"
#include "SignalPublisher.hpp"
#include "SignalObserver.hpp"
#include <verilated.h>

// This must be last so any "operator <<"" overloads work properly for test failures
#include <catch2/catch.hpp>

template<class Core>
struct BaseFixture {
    using SignalPublisher8 = SignalPublisher<uint8_t, Core>;
    using SignalObserver8 = SignalObserver<uint8_t, Core>;
    using SignalObserver16 = SignalObserver<uint16_t, Core>;
    TestBench<Core> bench;
    Core& core;
    BaseFixture() :
        core(bench.core())
    {
    }

    virtual ~BaseFixture() {}
};
