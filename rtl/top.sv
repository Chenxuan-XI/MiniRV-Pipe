`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/01/05 16:15:01
// Design Name: 
// Module Name: top
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


`timescale 1ns / 1ps

module top (
    input  logic        clk,
    input  logic        rst_n,
    output logic [7:0]  led
);

    // ========================
    // IF stage signals
    // ========================
    logic [31:0] pc_if;
    logic [31:0] instr_if;
    logic [4:0]  rs1_if;
    logic [4:0]  rs2_if;

    // IF/ID
    logic [31:0] pc_id;
    logic [31:0] instr_id;
    logic [4:0]  rs1_if_reg;
    logic [4:0]  rs2_if_reg;

    // ========================
    // ID stage signals
    // ========================
    logic [3:0]  opcode_id;
    logic [4:0]  rd_id;
    logic [31:0] rs1_val_id;
    logic [31:0] rs2_val_id;
    logic [31:0] imm_id;
    logic [4:0]  rs1_id;
    logic [4:0]  rs2_id;

    logic        is_load_id;
    logic        is_store_id;
    logic        reg_write_id;
    logic        alu_src_imm_id;
    logic [2:0]  alu_op_id;
    logic [31:0] pc_id_reg;

    // ========================
    // ID/EX
    // ========================
    logic [31:0] pc_ex;
    logic [3:0]  opcode_ex; // not used
    logic [4:0]  rd_ex;
    logic [31:0] rs1_val_ex;
    logic [31:0] rs2_val_ex;
    logic [31:0] imm_ex;
    logic [4:0] rs1_id_reg;
    logic [4:0] rs2_id_reg;

    logic        is_load_ex;
    logic        is_store_ex;
    logic        reg_write_ex;
    logic        alu_src_imm_ex;
    logic [2:0]  alu_op_ex;

    // ========================
    // EX stage
    // ========================        
    logic [4:0]  rd_ex_reg;
    logic        is_load_ex_reg;
    logic        is_store_ex_reg;
    logic        reg_write_ex_reg;
    logic [31:0] alu_res_ex;
    logic [31:0] store_data_ex;


    // ========================
    // EX/MEM
    // ========================
    logic [31:0] alu_res_mem;
    logic [31:0] store_data_mem;
    logic [4:0]  rd_mem;
    logic        is_load_mem;
    logic        is_store_mem;
    logic        reg_write_mem;

    // ========================
    // MEM stage
    // ========================
    logic [31:0] mem_addr;
    logic [31:0] mem_wdata;
    logic        mem_we;
    logic [31:0] mem_rdata;

    logic [31:0] mem_data_wb;
    logic [31:0] alu_res_wb;
    logic [4:0]  rd_wb;
    logic        is_load_wb;
    logic        reg_write_wb;

    // ========================
    // DATA MEM
    // ========================
    
    // ========================
    // MEM/WB
    // ========================
    logic [31:0] mem_data_wb_reg;
    logic [31:0] alu_res_wb_reg;
    logic [4:0]  rd_wb_reg;
    logic        is_load_wb_reg;
    logic        reg_write_wb_reg;

    // ========================
    // WB stage
    // ========================
    logic        wb_we;
    logic [4:0]  wb_rd;
    logic [31:0] wb_wdata;

    // ========================
    // Hazard Stage
    // ========================
    logic        load_use_hazard;
    logic        id_ex_flush;
    logic        pc_write;
    logic        ifid_write;

    // ========================
    // IF stage
    // ========================
    if_stage u_if (
        .clk      (clk),
        .rst_n    (rst_n),
        .pc       (pc_if),
        .instr    (instr_if),
        .pc_en    (pc_write),
        .rs1      (rs1_if),
        .rs2      (rs2_if)
    );

    if_id_reg u_if_id (
        .clk      (clk),
        .rst_n    (rst_n),
        .en       (ifid_write),

        .pc_in    (pc_if),
        .instr_in (instr_if),
        .rs1_in   (rs1_if),
        .rs2_in   (rs2_if),

        .pc_out   (pc_id),
        .instr_out(instr_id),
        .rs1_out  (rs1_if_reg),
        .rs2_out  (rs2_if_reg)
    );

    // ========================
    // ID stage
    // ========================
    id_stage u_id (
        .clk        (clk),
        .rst_n      (rst_n),
        .pc_in      (pc_id),
        .instr_in   (instr_id),

        .wb_we      (wb_we),
        .wb_rd      (wb_rd),
        .wb_wdata   (wb_wdata),

        .opcode     (opcode_id),
        .rd         (rd_id),
        .rs1_val    (rs1_val_id),
        .rs2_val    (rs2_val_id),
        .imm        (imm_id),
        .rs1d   (rs1_id),
        .rs2d   (rs2_id),


        .is_load    (is_load_id),
        .is_store   (is_store_id),
        .reg_write  (reg_write_id),
        .alu_src_imm(alu_src_imm_id),
        .alu_op     (alu_op_id),
        .pc_out     (pc_id_reg)
    );

    id_ex_reg u_id_ex (
        .clk            (clk),
        .rst_n          (rst_n),
        .flush          (id_ex_flush),

        .pc_in          (pc_id_reg),
        .rd_in          (rd_id),
        .rs1_val_in     (rs1_val_id),
        .rs2_val_in     (rs2_val_id),
        .imm_in         (imm_id),
        .opcode_in      (opcode_id),
        .rs1_in         (rs1_id),
        .rs2_in         (rs2_id),

        .is_load_in     (is_load_id),
        .is_store_in    (is_store_id),
        .reg_write_in   (reg_write_id),
        .alu_src_imm_in (alu_src_imm_id),
        .alu_op_in      (alu_op_id),

        .pc_out         (pc_ex),
        .rd_out         (rd_ex),
        .rs1_val_out    (rs1_val_ex),
        .rs2_val_out    (rs2_val_ex),
        .imm_out        (imm_ex),
        .opcode_out     (opcode_ex),
        .rs1_out        (rs1_id_reg),
        .rs2_out        (rs2_id_reg),

        .is_load_out    (is_load_ex),
        .is_store_out   (is_store_ex),
        .reg_write_out  (reg_write_ex),
        .alu_src_imm_out(alu_src_imm_ex),
        .alu_op_out     (alu_op_ex)
    );

    // ========================
    // Hazard Unit
    // ========================
    hazard_unit u_ha (
        .is_load        (is_load_ex),
        .rd             (rd_ex),
        .rs1            (rs1_if_reg),
        .rs2            (rs2_if_reg),
        .load_use_hazard(load_use_hazard),
        .id_ex_flush    (id_ex_flush),
        .pc_write       (pc_write),
        .ifid_write     (ifid_write)
    );

    // ========================
    // EX stage
    // ========================
    ex_stage u_ex (
        .pc_in          (pc_ex),
        .rd_in          (rd_ex),
        .rs1_val_in     (rs1_val_ex),
        .rs2_val_in     (rs2_val_ex),
        .imm_in         (imm_ex),
        .opcode_in      (opcode_ex),

        .is_load_in     (is_load_ex),
        .is_store_in    (is_store_ex),
        .reg_write_in   (reg_write_ex),
        .alu_src_imm    (alu_src_imm_ex),
        .alu_op         (alu_op_ex),
        .rs1_idx_in     (rs1_id_reg),
        .rs2_idx_in     (rs2_id_reg),
        .exmem_alu_res  (alu_res_mem),
        .exmem_rd       (rd_mem),
        .exmem_reg_write (reg_write_mem),
        .memwb_rd       (rd_wb_reg),
        .memwb_reg_write (reg_write_wb_reg),
        .memwb_wdata    (wb_wdata),


        .alu_res        (alu_res_ex),
        .store_data     (store_data_ex),
        .rd_out         (rd_ex_reg),
        .is_load_out    (is_load_ex_reg),
        .is_store_out   (is_store_ex_reg),
        .reg_write_out  (reg_write_ex_reg)
    );

    ex_mem_reg u_ex_mem (
        .clk            (clk),
        .rst_n          (rst_n),

        .alu_res_in     (alu_res_ex),
        .store_data_in  (store_data_ex),
        .rd_in          (rd_ex_reg),
        .is_load_in     (is_load_ex_reg),
        .is_store_in    (is_store_ex_reg),
        .reg_write_in   (reg_write_ex_reg),

        .alu_res_out    (alu_res_mem),
        .store_data_out (store_data_mem),
        .rd_out         (rd_mem),
        .is_load_out    (is_load_mem),
        .is_store_out   (is_store_mem),
        .reg_write_out  (reg_write_mem)
    );

    // ========================
    // MEM stage (simple data memory)
    // ========================
    mem_stage u_mem (
        .alu_res_in     (alu_res_mem),
        .store_data_in  (store_data_mem),
        .rd_in          (rd_mem),
        .is_load_in     (is_load_mem),
        .is_store_in    (is_store_mem),
        .reg_write_in   (reg_write_mem),

        .mem_rdata      (mem_rdata),

        .mem_addr       (mem_addr),
        .mem_wdata      (mem_wdata),
        .mem_we         (mem_we),

        .mem_data_out   (mem_data_wb),
        .alu_res_out    (alu_res_wb),
        .reg_write_out  (reg_write_wb),
        .rd_out         (rd_wb),
        .is_load_out    (is_load_wb)
    );

    data_memory u_data_mem (
        .clk   (clk),
        .we    (mem_we),
        .addr  (mem_addr),
        .wdata (mem_wdata),
        .rdata (mem_rdata)
    );

    mem_wb_reg u_mem_wb (
        .clk            (clk),
        .rst_n          (rst_n),

        .mem_data_in    (mem_data_wb),
        .alu_res_in     (alu_res_wb),
        .rd_in          (rd_wb),
        .is_load_in     (is_load_wb),
        .reg_write_in   (reg_write_wb),

        .mem_data_out   (mem_data_wb_reg),
        .alu_res_out    (alu_res_wb_reg),
        .rd_out         (rd_wb_reg),
        .is_load_out    (is_load_wb_reg),
        .reg_write_out  (reg_write_wb_reg)
    );

    wb_stage u_wb (
        .mem_data_in    (mem_data_wb_reg),
        .alu_res_in     (alu_res_wb_reg),
        .rd_in          (rd_wb_reg),
        .is_load_in     (is_load_wb_reg),
        .reg_write_in   (reg_write_wb_reg),

        .wb_we          (wb_we),
        .wb_rd          (wb_rd),
        .wb_wdata       (wb_wdata)
    );

    // ========================
    // Simple demo output
    // ========================
    assign led = pc_if[7:0];
    always @(posedge clk) begin
        if (load_use_hazard)
            $display("STALL @ PC=%h", pc_if);
    end
    always_ff @(posedge clk) begin
        $display("T=%0t PC=%h | HAZ=%b | EX: rd=%0d regW=%b isLd=%b | MEM: rd=%0d regW=%b isLd=%b | WB: rd=%0d regW=%b isLd=%b wdata=%h",
            $time, pc_if, load_use_hazard,
            rd_ex_reg, reg_write_ex_reg, is_load_ex_reg,
            rd_mem,    reg_write_mem,    is_load_mem,
            rd_wb_reg, reg_write_wb_reg, is_load_wb_reg, wb_wdata
        );
    end


endmodule

