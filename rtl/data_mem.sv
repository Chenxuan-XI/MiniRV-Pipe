`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/01/06 23:09:24
// Design Name: 
// Module Name: data_mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module data_memory #(
    parameter WIDTH = 32,
    parameter DEPTH = 256   // 256 words = 1KB
) (
    input  logic              clk,
    input  logic              we,
    input  logic [WIDTH-1:0]  addr,
    input  logic [WIDTH-1:0]  wdata,

    output logic [WIDTH-1:0]  rdata
);

    // word-addressed memory
    logic [WIDTH-1:0] mem [0:DEPTH-1];

    // write: synchronous
    always_ff @(posedge clk) begin
        if (we) begin
            mem[addr[9:2]] <= wdata;   // word aligned: 1 word = 4 bytes
        end
    end

    always_ff @(posedge clk) begin
        if (we) begin
            $display("DMEM WRITE: addr=%0d data=%0d",addr[9:2], wdata);
            mem[addr[9:2]] <= wdata;
        end
    end

    // read: asynchronous (simplest)
    assign rdata = mem[addr[9:2]];

endmodule

