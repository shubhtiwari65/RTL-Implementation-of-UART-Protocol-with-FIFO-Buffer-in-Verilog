module uart_rx #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 1000000
)(
    input  wire       clk,
    input  wire       reset,
    input  wire       rx,
    output reg [7:0]  data_out,
    output reg        rx_done
);

    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;
    reg [1:0] state;

    wire tick;

    localparam IDLE = 2'd0, START = 2'd1, DATA = 2'd2, STOP = 2'd3;

    // Internal baud generator
    baud_gen #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) 
    baud_rx_gen (
        .clk(clk),
        .reset(reset),
        .tick(tick)
    );

    always @(posedge clk or posedge reset) 
    begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 0;
            rx_done <= 0;
            data_out <= 8'd0;
        end else begin
            case (state)
                IDLE:
                 begin
                    if (~rx) 
                    begin // start bit detected
                        state <= START;
                        bit_cnt <= 0;
                    end
                end
                START: if (tick) state <= DATA;
                DATA: if (tick) 
                begin
                    shift_reg <= {rx, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 7) state <= STOP;
                end
                STOP: if (tick) 
                begin
                    data_out <= shift_reg;
                    rx_done <= 1;
                    state <= IDLE;
                end
            endcase

            if (rx_done) rx_done <= 0;
        end
    end
endmodule
