`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/01/08 15:46:52
// Design Name: 
// Module Name: tb_top
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

module tb_top;

    // ========================
    // Clock / Reset
    // ========================
    logic clk;
    logic rst_n;

    // ========================
    // DUT outputs
    // ========================
    logic [7:0] led;

    // ========================
    // Instantiate DUT
    // ========================
    top dut (
        .clk   (clk),
        .rst_n (rst_n),
        .led   (led)
    );

    // ========================
    // Clock generation: 100MHz
    // ========================
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 10ns period
    end

    // ========================
    // Reset sequence
    // ========================
    initial begin
        rst_n = 0;
        #50;
        rst_n = 1;
    end

    // ========================
    // Instruction memory init
    // ========================
    initial begin
        wait(rst_n == 1);

        // ADD x1, x0, x0   ; x1 = 0
        dut.u_if.rom_pc.mem[0] = 32'h0080_0000;

        // ADD x2, x1, 7    ; x1 = 0
        dut.u_if.rom_pc.mem[1] = 32'h3104_0007;

        // NOP
        // dut.u_if.rom_pc.mem[2] = 32'h0000_0000;
        // dut.u_if.rom_pc.mem[3] = 32'h0000_0000;
        // dut.u_if.rom_pc.mem[4] = 32'h0000_0000;

        // STORE x2 -> MEM[2] (mem[i] ← address = i * 4)
        dut.u_if.rom_pc.mem[2] = 32'h9000_4008;

        // LOAD x3 <- MEM[2]
        dut.u_if.rom_pc.mem[3] = 32'h8180_0008;

        // ADD x4 x0 x3
        dut.u_if.rom_pc.mem[4] = 32'h0200_6000;

        // ADD x5 x4 x4
        dut.u_if.rom_pc.mem[5] = 32'h0290_8000;

        $display("[TB] Instruction memory initialized");

    end

    // ========================
    // register name forwarding testbench
    // ========================
    // initial begin
    //     wait (rst_n == 1);
    //     dut.u_if.rom_pc.mem[0] = 32'h30800008; // OP_ADDI=3, rd=1, rs1=0, rs2=0, imm=8
    //     dut.u_if.rom_pc.mem[1] = 32'h01042000; // OP_ADD =0, rd=2, rs1=1, rs2=1, imm=0
    //     dut.u_if.rom_pc.mem[2] = 32'h01882000; // OP_ADD =0, rd=3, rs1=2, rs2=1, imm=0
    //     dut.u_if.rom_pc.mem[3] = 32'h00000000;
    //     dut.u_if.rom_pc.mem[4] = 32'h00000000;
    //     dut.u_if.rom_pc.mem[5] = 32'h00000000;
    //     $display("[TB] Instruction memory initialized");
    // end

    // =======================
    // STORE FORWARD TEST
    // =======================

    // initial begin
    //     wait(rst_n == 1);
    //     dut.u_if.rom_pc.mem[0] = 32'h00000000;
    //     dut.u_if.rom_pc.mem[1] = 32'h30800007; // ADDI  rd=1 rs1=0 imm=7
    //     dut.u_if.rom_pc.mem[2] = 32'h90002000; // STORE rs2=1 rs1=0 imm=0
    //     dut.u_if.rom_pc.mem[3] = 32'h82000000; // LOAD  rd=2 rs1=0 imm=0

    //     $display("[TB] Program loaded for STORE forwarding test");
    // end



    // ========================
    // Simulation control
    // ========================
    initial begin
        #2000;

        $display("=================================");
        $display("Simulation finished");
        $display("LED = %h", led);
        $display("=================================");

        $finish;
    end

    // ========================
    // Optional monitors
    // ========================
    initial begin
        $display("Time\tPC\tWB_WE\tWB_RD\tWB_WDATA");
        $monitor("%0t\t%h\t%b\t%0d\t%h",
                 $time,
                 dut.pc_if,
                 dut.wb_we,
                 dut.wb_rd,
                 dut.wb_wdata);
    end

endmodule

