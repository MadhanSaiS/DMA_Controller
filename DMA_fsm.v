`timescale 1ns / 1ps
module DMA_fsm(
    input wire clk,rst,start,DMA_ack,counter_zero,
    input wire done_ack,    //from cpu
    output reg req,read_en,write_en,update_en,done
    );
    
    //State Encoding(One-Hot)
    parameter IDLE    = 6'b000001;
    parameter REQ     = 6'b000010;
    parameter READ    = 6'b000100;
    parameter WRITE   = 6'b001000;
    parameter UPDATE  = 6'b010000;
    parameter DONE    = 6'b100000;
    reg [5:0] current_state,next_state;
    
    //Current_state Logic
    always@(posedge clk or posedge rst) begin
        if(rst)
            current_state<=IDLE;
        else
            current_state<=next_state;
    end
    
    //Next_state Logic
    always@(*) begin
         case(current_state)
            IDLE: begin
                if(start)
                    next_state = REQ;
                else
                    next_state = IDLE;
            end
            
            REQ: begin
                if(DMA_ack)
                    next_state = READ;
                else
                    next_state = REQ;
            end
            
            READ: begin
                next_state = WRITE;
            end
            
            WRITE: begin
                next_state = UPDATE;
            end
            
            UPDATE: begin
                if(counter_zero)
                    next_state = DONE;
                else
                    next_state = READ;//loopback to read next bit and write onto memory
            end
            
            DONE: begin
                if(done_ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            
            default: next_state = IDLE;
        endcase
    end
    
    //OUtput Logic (Moore MAchine)
    always@(*) begin
        req         = 1'b0;
        read_en     = 1'b0;
        write_en    = 1'b0;
        update_en   = 1'b0;
        done        = 1'b0;
        
        case(current_state)
            IDLE: begin
            end
            
            REQ: begin
                req = 1'b1;
            end
            
            READ: begin
                read_en = 1'b1;
            end
            
            WRITE: begin
                write_en = 1'b1;
            end
            
            UPDATE: begin
                update_en = 1'b1;
            end
            
            DONE: begin
                done = 1'b1;
            end
        endcase
    end
    
endmodule
