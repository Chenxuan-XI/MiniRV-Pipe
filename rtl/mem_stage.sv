`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/01/01 18:54:11
// Design Name: 
// Module Name: mem_stage
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


module mem_stage #(
    parameter WIDTH = 32
) (
    input  logic [WIDTH-1:0] alu_res_in,
    input  logic [WIDTH-1:0] store_data_in,
    input  logic [4:0]       rd_in,
    input  logic             is_load_in,
    input  logic             is_store_in,

    input  logic [WIDTH-1:0] mem_rdata,   // read from data_mem

    output logic [WIDTH-1:0] mem_addr,
    output logic [WIDTH-1:0] mem_wdata,
    output logic             mem_we,

    output logic [WIDTH-1:0] mem_data_out, // to WB
    output logic [WIDTH-1:0] alu_res_out,  // to WB
    output logic [4:0]       rd_out
);

always_comb begin
    mem_addr = alu_res_in;
    mem_wdata = '0;
    mem_we = 1'b0;
    mem_data_out = '0;
    
    rd_out = rd_in;
    alu_res_out = alu_res_in;

    if(is_load_in) begin
        mem_data_out = mem_rdata;
    end

    if(is_store_in) begin
        mem_wdata = store_data_in;
        mem_we = 1'b1;
    end
end

endmodule
