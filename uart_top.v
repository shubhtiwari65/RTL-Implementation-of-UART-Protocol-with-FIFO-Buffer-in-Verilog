module uart_top (
    input  wire       clk,
    input  wire       reset,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output wire       tx,
    input  wire       rx,
    output wire [7:0] rx_data,
    output wire       rx_done
);

    // UART Configurations
    localparam CLK_FREQ  = 50_000_000;
    localparam BAUD_RATE = 1_000_000;

    wire tick;

    // Baud rate generator (shared tick for both TX and RX)
    baud_gen #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) baud_gen_inst (
        .clk(clk),
        .reset(reset),
        .tick(tick)
    );

    // UART Transmitter
    uart_tx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) tx_inst (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .data_in(tx_data),
        .tx(tx),
        .tx_done() // 
    );

    // UART Receiver
    uart_rx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) rx_inst (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        //.tick(tick),
        .data_out(rx_data),
        .rx_done(rx_done)
    );

endmodule



// iverilog -o uart.vvp uart_tb.v uart_top.v uart_tx.v uart_rx.v baud_gen.v 