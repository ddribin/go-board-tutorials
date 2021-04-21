`ifndef _STATE_MACHINE_VH
`define _STATE_MACHINE_VH

`define STATE_WIDTH   3
// Bit 3 represents a running state: 0 = not running, 1 = running
`define STATE_INIT        3'b000
`define STATE_RESET_WAIT  3'b001
`define STATE_AUTO        3'b100
`define STATE_SWITCH      3'b101
`define STATE_BIT         3'b110

`endif
