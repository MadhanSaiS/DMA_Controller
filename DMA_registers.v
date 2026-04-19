`timescale 1ns / 1ps
module DMA_registers(
    input wire clk,rst,
    
    input wire wr_en,   //from CPU interface(custom input)
    input wire [1:0] addr,
    input wire [31:0] wdata,    //write data
    
    //from DMA
    input wire done,
    
    //output to DMA
    output reg [31:0] src_addr,
    output reg [31:0] dst_addr,
    output reg [15:0] size,
    output reg start,
    output reg status_done
    );
    
    always@(posedge clk) begin
        if(rst) begin
            src_addr <= 32'd0;
            dst_addr <= 32'd0;
            size     <= 16'd0;
            start    <= 1'b0;
            status_done <= 1'b0;
        end
        else begin
            //from CPU
            if(wr_en) begin
                case(addr)
                    2'b00: src_addr <= wdata;
                    2'b01: dst_addr <= wdata;
                    2'b10: size     <= wdata[15:0];
                    2'b11: start    <= wdata[0];
                endcase
            end
            //DMA update status if completed
            if(done) begin
                status_done <= 1'b1;
                start       <= 1'b0;
            end
        end
    end
    
endmodule
