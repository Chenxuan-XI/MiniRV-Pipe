`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/20 17:52:06
// Design Name: 
// Module Name: tb_if_id_reg
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


module tb_if_id_reg;
    logic [31:0] pc_in;
    logic [31:0] pc_out;
    logic [31:0] instr_in;
    logic [31:0] instr_out;
    logic clk;
    logic rst_n;

    if_id_reg #(
        .WIDTH(32), 
        .DEPTH(64)
        ) dut (
        .pc_in(pc_in),
        .pc_out(pc_out),
        .instr_in(instr_in),
        .instr_out(instr_out),
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

    initial begin
        pc_in    = 0;
        instr_in = 0;

        @(posedge rst_n);

        #2;
        pc_in    = 32'd0;
        instr_in = 32'h1111;

        #10;
        pc_in    = 32'd4;
        instr_in = 32'h2222;

        #10;
        pc_in    = 32'd8;
        instr_in = 32'h3333;

        #10;
        pc_in    = 32'd12;
        instr_in = 32'h4444;
    end



endmodule
