module uart_tx #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 1_000_000
)(
    input  wire       clk,
    input  wire       reset,
    input  wire       tx_start,
    input  wire [7:0] data_in,
    output reg        tx,
    output reg        tx_done
);

    // FSM states
    localparam IDLE = 1'b0,
               SEND = 1'b1;

    reg state;
    reg [3:0] bit_cnt;
    reg [9:0] shift_reg;
    wire tick;

    // Instantiate baud generator
    baud_gen #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) baud_tx_gen (
        .clk(clk),
        .reset(reset),
        .tick(tick)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx       <= 1'b1;
            tx_done  <= 1'b0;
            bit_cnt  <= 4'd0;
            shift_reg <= 10'b1111111111;
            state    <= IDLE;
        end else begin
            tx_done <= 1'b0; // default

            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    if (tx_start) begin
                        shift_reg <= {1'b1, data_in, 1'b0}; // stop, data, start
                        bit_cnt <= 0;
                        state <= SEND;
                    end
                end

                SEND: begin
                    if (tick) begin
                        tx <= shift_reg[0];
                        shift_reg <= {1'b1, shift_reg[9:1]}; // right shift with stop bit
                        bit_cnt <= bit_cnt + 1;

                        if (bit_cnt == 9) begin
                            tx_done <= 1'b1;
                            state <= IDLE;
                        end
                    end
                end
            endcase
        end
    end
endmodule
