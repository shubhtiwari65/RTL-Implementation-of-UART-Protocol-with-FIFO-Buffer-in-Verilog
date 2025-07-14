

`timescale 1ns/1ps

module uart_tb;

    reg clk = 0;
    reg reset = 1;
    reg tx_start = 0;
    reg [7:0] tx_data = 8'b10100101;  // A5
    wire tx, rx;
    wire [7:0] rx_data;
    wire rx_done;

    // DUT instantiation
    uart_top uut (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .rx(tx),            // loopback
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // 50 MHz clock => 20 ns period
    always #10 clk = ~clk;

    initial begin
        $display("=== UART Basic Test @ 1 Mbps ===");
        $dumpfile("uart.vcd");
        $dumpvars(0, uart_tb);

        // Step 1: Apply reset
        reset = 1;
        #100;
        reset = 0;
        $display("[%t ns] Reset Deasserted", $time);

        // Step 2: Send one byte
        #100;
        tx_start = 1;
        $display("[%t ns] TX Start: Sending %b", $time, tx_data);
        #20;
        tx_start = 0;

        // Step 3: Wait for RX done
        wait(rx_done);
        $display("[%t ns] RX Done: Received %b", $time, rx_data);

        // Step 4: Finish
        #200;
        $display("[%t ns] Simulation Finished", $time);
        $finish;
    end

endmodule


// ==== UART TEST START ====
// [0] Applying Reset
// [100] Releasing Reset
// [200] Starting TX of Byte: 10100101
// [220] TX Start Pulse Sent
// [13280] RX Done! Received Byte: 10100101
// [13500] Ending Simulation
