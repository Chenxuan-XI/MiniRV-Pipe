`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/20 17:33:05
// Design Name: 
// Module Name: if_id_reg
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


module if_id_reg#(
    parameter WIDTH = 32,
    parameter DEPTH = 64
) (
        input  logic [WIDTH-1:0] pc_in,
        input  logic [WIDTH-1:0] instr_in,
        input  logic [4:0]       rs1_in,
        input  logic [4:0]       rs2_in,

        input  logic en,
        input  logic clk,
        input  logic rst_n,

        output logic [WIDTH-1:0] pc_out,
        output logic [WIDTH-1:0] instr_out,
        output logic [4:0]       rs1_out,
        output logic [4:0]       rs2_out    
);

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            pc_out <= '0;
            instr_out <= '0;
            rs1_out <= '0;
            rs2_out <= '0;
        end else if(en) begin
            pc_out <= pc_in;
            instr_out <= instr_in;
            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
        end else begin
            pc_out <= pc_out;
            instr_out <= instr_out;
            rs1_out <= rs1_out;
            rs2_out <= rs2_out;
        end            
    end

endmodule
