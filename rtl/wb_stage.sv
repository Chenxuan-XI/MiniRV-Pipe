`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/01/01 19:38:14
// Design Name: 
// Module Name: wb_stage
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

module wb_stage #(
    parameter WIDTH = 32
) (
    input  logic [WIDTH-1:0] mem_data_in,
    input  logic [WIDTH-1:0] alu_res_in,
    input  logic [4:0]       rd_in,
    input  logic             is_load_in,
    input  logic             reg_write_in,

    output logic             wb_we,
    output logic [4:0]       wb_rd,
    output logic [WIDTH-1:0] wb_wdata
);


always_comb begin
    wb_we    = 1'b0;
    wb_rd    = rd_in;
    wb_wdata = '0;
    if(reg_write_in) begin
        if (is_load_in) begin
            wb_we    = 1'b1;
            wb_wdata = mem_data_in;
        end else if (rd_in != 5'd0) begin
            wb_we    = 1'b1;
            wb_wdata = alu_res_in;
        end
    end
end


endmodule
