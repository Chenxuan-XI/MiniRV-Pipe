module if_stage #(
    parameter WIDTH = 32
) (
    input  logic clk,
    input  logic rst_n,
    output logic [WIDTH-1:0] pc,
    output logic [WIDTH-1:0] instr
);

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        pc <= '0;
    end
    else begin
        pc <= pc + WIDTH'(4);
    end
end

instr_rom rom_pc (
    .WIDTH(WIDTH)
    .DEPTH(64)
    .addr(pc),
    .instr(instr)
);

endmodule