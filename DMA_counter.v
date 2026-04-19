`timescale 1ns / 1ps
module DMA_counter(
    input wire clk, rst, load, enable, [15:0]size,
    output wire counter_zero
    );
    
    reg[15:0] counter;
    reg loaded; //tells whether counter is loaded
    
    //counter
    always@(posedge clk) begin
        if(rst) begin
            counter <= 16'd0;
            loaded <= 1'b0;
        end
        else if(load) begin
            counter<=size;                  //load data length
            loaded <= 1'b1;
        end
        else if(enable && counter!=0) begin
            counter <= counter - 1;         //reduce count
            end
    end
    
    //Flagging when count is zero
    assign counter_zero = loaded && (counter == 16'd0);
    
endmodule
