#ifndef CLOCKED_LOGIC_INTRO_H
#define CLOCKED_LOGIC_INTRO_H

#include "VClocked_Logic_Intro.h"

class Clocked_Logic_Intro : public VClocked_Logic_Intro {
public:
    uint8_t getClock() { return i_Clk; };
    void setClock(uint8_t clock) { i_Clk = clock; }
};

#endif // CLOCKED_LOGIC_INTRO_H