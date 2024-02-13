`timescale 1ns / 1ps

// coding for UART verification circuit
module UART_top
(
    input logic clk, 
    input logic rx,
    input logic  btnC,
    output logic tx,
    output logic [3:0] an,
    output logic [7:0] seg, led
);

// signals
logic tx_full, rx_empty, btn_tick;
logic [7:0] rec_data, rec_data1;

// instantiations
UART uart_unit(.clk(clk), .reset(1'b0), .rd_uart(btn_tick), .wr_uart(btn_tick), .rx(rx), .w_data(rec_data1), .tx_full(tx_full), .rx_empty(rx_empty), .r_data(rec_data), .tx(tx));
Debounce btn_db_unit(.clk(clk), .reset(1'b0), .sw(btnC), .db_level(), .db_tick(btn_tick));

// incremented data loops back
assign rec_data1 = rec_data + 1;

// LED display
assign led = rec_data;
assign an = 4'b1110;
assign seg = {1'b1, ~tx_full, 2'b11, ~rx_empty, 3'b111};

endmodule
