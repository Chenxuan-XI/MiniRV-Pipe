`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/22 16:28:24
// Design Name: 
// Module Name: id_stage
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

import minirv_types::*;

module if_stage #(
    parameter WIDTH = 32,
    parameter DEPTH = 64
) (
    input  logic clk,
    input  logic rst_n,
    input  logic pc_en,
    output logic [WIDTH-1:0] pc,
    output logic [WIDTH-1:0] instr,
    output logic [4:0]       rs1,
    output logic [4:0]       rs2
);



always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        pc <= '0;
    end else if (pc_en) begin
        pc <= pc + WIDTH'(4);
    end else begin
        pc <= pc; //stall

    end
end

instr_rom #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) rom_pc(
    .addr(pc),
    .instr(instr)
);

assign rs1 = instr[RS1_HI:RS1_LO];
assign rs2 = instr[RS2_HI:RS2_LO];

endmodule