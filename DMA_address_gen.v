`timescale 1ns / 1ps
module DMA_address_gen(
    input wire clk, rst, 
    input wire enable,  //from FSM(update_en)
    input wire load,    //from initial input address at begin
    input wire [31:0] src_addr_in, dst_addr_in,
    output reg [31:0]src_addr, dst_addr
    );
    
    //updating address
    always@(posedge clk) begin
        if(rst) begin
            src_addr <= 32'd0;
            dst_addr <= 32'd0;
        end
        else if(load) begin
            src_addr <= src_addr_in;
            dst_addr <= dst_addr_in;
        end
        else if (enable) begin
            src_addr <= src_addr + 4; //32 bit data = 4bytes (each transfer moves 4bytes)
            dst_addr <= dst_addr + 4;
        end
    end
               
endmodule
