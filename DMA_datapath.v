`timescale 1ns / 1ps
module DMA_datapath(
    input wire clk,rst,
    input wire read_en,     //from FSM
    input wire write_en,    //from FSM
    input wire [31:0] data_in,  //from memeory
    
    output reg [31:0] data_out  //to memory
    );
    
    reg [31:0] temp_data_reg;   //temp reg for storing data
    
    //Input
    always@(posedge clk)begin
        if(rst) begin
            temp_data_reg <= 32'd0;
        end
        else if (read_en) begin
            temp_data_reg <= data_in;
        end
    end
    
    //Output
    always@(*) begin
        if(write_en)
            data_out = temp_data_reg;
        else
            data_out = 32'd0;
    end
    
endmodule
