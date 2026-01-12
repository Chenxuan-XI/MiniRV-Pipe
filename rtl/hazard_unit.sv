`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/01/12 11:23:38
// Design Name: 
// Module Name: hazard_unit
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


module hazard_unit #(
    parameter WIDTH = 32
) (
    input  logic       is_load,
    input  logic [4:0] rd,
    input  logic [4:0] rs1,
    input  logic [4:0] rs2,

    output logic load_use_hazard,
    output logic id_ex_flush,
    output logic pc_write,
    output logic ifid_write
);

always_comb begin
    load_use_hazard = 1'b0;
    if(is_load && (rd != 0) && ((rd == rs1) || (rd == rs2))) load_use_hazard = 1'b1;
    else load_use_hazard = 1'b0;
end

assign id_ex_flush = load_use_hazard;
assign pc_write    = ~load_use_hazard;
assign ifid_write  = ~load_use_hazard;

endmodule
