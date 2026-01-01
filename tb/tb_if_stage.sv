`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/18 18:35:29
// Design Name: 
// Module Name: tb_if_stage
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


module tb_if_stage;

  logic [31:0] pc;
  logic [31:0] instr;
  logic rst_n;
  logic clk;

  // DUT
  if_stage #(.WIDTH(32) .DEPTH(64)) dut (
    .pc(pc),
    .instr(instr),
    .clk(clk),
    .rst_n(rst_n)
  );

    initial begin
    clk = 0;
    forever #5 clk = ~clk;
    end

    initial begin
    rst_n = 0;
    #20;
    rst_n = 1;

    #100;
    $stop;
    end


endmodule
