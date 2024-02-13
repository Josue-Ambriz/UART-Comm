`timescale 1ns / 1ps

// coding for FIFO buffer consisting of a controller and register file
module FIFO
#(parameter DATA_WIDTH = 8, // number of bits in a word
    ADDR_WIDTH = 4)         // number of address bits
(   // I/O ports
    input logic clk, reset,
    input logic rd, wr,
    input logic [DATA_WIDTH-1:0] w_data,
    output logic empty, full,
    output logic [DATA_WIDTH-1:0] r_data
);

//signals
logic [ADDR_WIDTH-1:0] w_addr, r_addr;
logic wr_en, full_temp;

// write enabled only when FIFO is not full
assign wr_en = wr & ~full_temp;
assign full = full_temp;

// instantiations
FIFO_ctrl #(.ADDR_WIDTH(ADDR_WIDTH)) c_unit(.*, .full(full_temp));
Register #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) f_unit(.*);
    
endmodule
