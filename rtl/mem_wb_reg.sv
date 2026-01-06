`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/01/01 19:26:43
// Design Name: 
// Module Name: mem_wb_reg
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


module mem_wb_reg #(
    parameter WIDTH = 32
) (
    input  logic [WIDTH-1:0] mem_data_in,
    input  logic [WIDTH-1:0] alu_res_in,
    input  logic [4:0]       rd_in,
    input  logic             is_load_in,
    input  logic             reg_write_in,

    input  logic             clk,
    input  logic             rst_n,

    output logic [WIDTH-1:0] mem_data_out,
    output logic [WIDTH-1:0] alu_res_out,
    output logic [4:0]       rd_out,
    output logic             is_load_out,
    output logic             reg_write_out
);

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mem_data_out <= '0;
        alu_res_out <= '0;
        rd_out <= '0;
        reg_write_out <= 1'b0;
        is_load_out <= 1'b0;
    end else begin
        mem_data_out <= mem_data_in;
        alu_res_out <= alu_res_in;
        rd_out <= rd_in;
        reg_write_out <= reg_write_in;
        is_load_out <= is_load_in;
    end
end

endmodule
