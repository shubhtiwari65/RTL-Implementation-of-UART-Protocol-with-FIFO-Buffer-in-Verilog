module baud_gen #(
    parameter integer CLK_FREQ = 50000000,
    parameter integer BAUD_RATE = 1000000
)(
    input  wire clk,
    input  wire reset,
    output reg  tick
);
    localparam integer BAUD_TICKS = CLK_FREQ / BAUD_RATE;
    integer counter = 0;

    always @(posedge clk or posedge reset)
     begin
        if (reset) 
        begin
            counter <= 0;
            tick <= 0;
        end
         else
          begin
            if (counter == BAUD_TICKS - 1)
                begin
                counter <= 0;
                tick <= 1;
                end 
            else 
                begin
                counter <= counter + 1;
                tick <= 0;
                end
        end
    end

    initial 
     begin
        $display("✔️ BAUD GEN -> CLK_FREQ = %d, BAUD_RATE = %d, BAUD_TICKS = %d", CLK_FREQ, BAUD_RATE, BAUD_TICKS);
     end
endmodule
