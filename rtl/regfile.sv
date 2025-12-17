`timescale 1ns / 1ps
module RegFile #(
    parameter WIDTH = 32,
    parameter DEPTH = 32,
    parameter READ_ASYNC = 1
)(
    input  logic              clk,
    input  logic              rst_n,
    input  logic              we,
    input  logic  [4:0]       waddr,
    input  logic  [WIDTH-1:0] wdata,
    input  logic  [4:0]       raddr1,
    input  logic  [4:0]       raddr2,
    output logic [WIDTH-1:0]  rdata1,
    output logic [WIDTH-1:0]  rdata2
);

logic [WIDTH-1:0] regfile [0:DEPTH-1];

always_ff @(posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
        for(int i = 0; i < DEPTH; i++) begin
            regfile[i] <= 0;
        end
    end
    else begin
        if(we) begin
            if(waddr != 0) begin
                regfile[waddr] <= wdata;
            end
        end
    end
end

generate
if (READ_ASYNC) begin : gen_async_read
    // Asynchronous Read
    always_comb begin
        rdata1 = (raddr1 == 5'd0) ? '0 : regfile[raddr1];
        rdata2 = (raddr2 == 5'd0) ? '0 : regfile[raddr2];
        // if (we && (waddr != 5'd0) && (waddr == raddr1)) rdata1 = wdata;
        // if (we && (waddr != 5'd0) && (waddr == raddr2)) rdata2 = wdata;
    end
end else begin : gen_sync_read
    // Synchronous Read
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rdata1 <= '0;
            rdata2 <= '0;
        end else begin
            logic [WIDTH-1:0] d1, d2;
            d1 = (raddr1 == 5'd0) ? '0 : regfile[raddr1];
            d2 = (raddr2 == 5'd0) ? '0 : regfile[raddr2];
            if (we && (waddr != 5'd0) && (waddr == raddr1)) d1 = wdata;
            if (we && (waddr != 5'd0) && (waddr == raddr2)) d2 = wdata;
            rdata1 <= d1;
            rdata2 <= d2;
        end
    end
end
endgenerate

endmodule
