`timescale 1ns / 1ps

// coding for UART file consisting of baud generator, FIFOs, UART rx/tx
module UART
#( // Default setting:
    // 19,200 baud, 8 data bits, 1 stop bit, 2^2 FIFO
    parameter DBIT = 8,       // # data bits
              SB_TICK = 16,   // # ticks for stop bits, 16/24/32
                              // for 1/1.5/2 stop bits
              DVSR = 326,     // baud rate divisor
                              // DVSR = 100M/(16*baud rate)
              //DVSR_BIT = 8,   // # bits of DVSR
              FIFO_W = 2      // # addr bits of FIFO
                              // # words in FIFO=2^FIFO_W
)
(   // I/O ports
    input logic clk, reset,
    input logic rd_uart, wr_uart, rx,
    input logic [7:0] w_data,
    output logic tx_full, rx_empty, tx,
    output logic [7:0] r_data
);

// signals
logic tick, rx_done_tick, tx_done_tick;
logic tx_empty, tx_fifo_not_empty;
logic [7:0] tx_fifo_out, rx_data_out;

// instantiations
Baud_Gen baud_gen_unit (.clk(clk), .reset(reset), .dvsr(DVSR), .tick(tick));
UART_rx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_rx_unit(.clk(clk), .reset(reset), .rx(rx), .s_tick(tick), .rx_done_tick(rx_done_tick), .dout(rx_data_out));
FIFO #(.DATA_WIDTH(DBIT), .ADDR_WIDTH(FIFO_W)) fifo_rx_unit(.clk(clk), .reset(reset), .rd(rd_uart), .wr(rx_done_tick), .w_data(rx_data_out), .empty(rx_empty), .full(), .r_data(r_data));
FIFO #(.DATA_WIDTH(DBIT), .ADDR_WIDTH(FIFO_W)) fifo_tx_unit(.clk(clk), .reset(reset), .rd(tx_done_tick), .wr(wr_uart), .w_data(w_data), .empty(tx_empty), .full(tx_full), .r_data(tx_fifo_out));
UART_tx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_tx_unit(.clk(clk), .reset(reset), .tx_start(tx_fifo_not_empty), .s_tick(tick), .din(tx_fifo_out), .tx_done_tick(tx_done_tick), .tx(tx));

// outputs
assign tx_fifo_not_empty = ~tx_empty;
    
endmodule
