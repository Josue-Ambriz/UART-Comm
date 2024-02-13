`timescale 1ns / 1ps

// coding for baud generator
module Baud_Gen
( // I/O ports
    input logic clk, reset,
    input logic [10:0] dvsr,
    output logic tick
);

// signals
logic [10:0] r_reg;
logic [10:0] r_next;

// next state logic
always_ff @(posedge clk, posedge reset)
    if (reset)
        r_reg <=0;
    else 
        r_reg <= r_next;

// outputs
assign r_next = (r_reg == dvsr) ? 0 : r_reg+1;
assign tick = (r_reg == 1);

endmodule
