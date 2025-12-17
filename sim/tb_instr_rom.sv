`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/17 18:14:14
// Design Name: 
// Module Name: tb_instr_rom
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

`timescale 1ns/1ps
module tb_instr_rom;

  logic [31:0] addr;
  logic [31:0] instr;

  // DUT
  instr_rom #(.WIDTH(32), .DEPTH(64)) dut (
    .addr(addr),
    .instr(instr)
  );

  initial begin
    addr = 32'd0;
    #10;

    addr = 32'd4;
    #10;

    addr = 32'd8;
    #10;

    addr = 32'd12;
    #10;

    addr = 32'd256;   // over the range
    #10;

    $stop;
  end

endmodule
