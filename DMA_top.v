module DMA_top (
    input  wire clk,
    input  wire rst,

    // CPU interface
    input  wire     wr_en,
    input  wire [1:0] addr,
    input  wire [31:0] wdata,

    // Memory interface
    input  wire [31:0] data_in,
    input  wire        DMA_ack,
    input  wire        done_ack,

    output wire [31:0] data_out,
    output wire [31:0] addr_out,
    output wire        read_en,
    output wire        write_en,
    output wire        DMA_req,
    output wire        done,
    output wire        status_done
);

    //wires in between blocks
    wire [31:0] src_addr, dst_addr;
    wire [15:0] size;
    wire        start;
    wire        counter_zero;
    wire        update_en;

    wire [31:0] curr_src_addr, curr_dst_addr;

    //Registers
    DMA_registers duv_regs (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .addr(addr),
        .wdata(wdata),
        .done(done),

        .src_addr(src_addr),
        .dst_addr(dst_addr),
        .size(size),
        .start(start),
        .status_done(status_done)
    );

    //FSM
    DMA_fsm duv_fsm (
        .clk(clk),
        .rst(rst),
        .start(start),
        .DMA_ack(DMA_ack),
        .counter_zero(counter_zero),
        .done_ack(done_ack),

        .req(DMA_req),
        .read_en(read_en),
        .write_en(write_en),
        .update_en(update_en),
        .done(done)
    );

    //Counter
    DMA_counter duv_counter (
        .clk(clk),
        .rst(rst),
        .load(start),
        .enable(update_en),
        .size(size),
        .counter_zero(counter_zero)
    );

    //Address Generator
    DMA_address_gen duv_addr (
        .clk(clk),
        .rst(rst),
        .load(start),
        .enable(update_en),
        .src_addr_in(src_addr),
        .dst_addr_in(dst_addr),
        .src_addr(curr_src_addr),
        .dst_addr(curr_dst_addr)
    );

    //Datapath
    DMA_datapath duv_data (
        .clk(clk),
        .rst(rst),
        .read_en(read_en),
        .write_en(write_en),
        .data_in(data_in),
        .data_out(data_out)
    );

    //Address MUX
    assign addr_out = (read_en) ? curr_src_addr :(write_en) ? curr_dst_addr :32'd0;

endmodule