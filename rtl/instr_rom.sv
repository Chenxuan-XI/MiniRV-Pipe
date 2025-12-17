module instr_rom #(
    parameter WIDTH = 32,
    parameter DEPTH = 64
) (
    input  logic [WIDTH-1:0] addr,
    output logic [WIDTH-1:0] instr
);

logic [WIDTH-1:0] mem [0:DEPTH-1];
logic [$clog2(DEPTH)-1:0] index;
localparam int IMEM_BYTES = DEPTH * 4;

initial $readmemh("program.hex", mem);

always_comb begin
    instr = 32'hDEADBEEF;
    index = '0;

    if(addr < IMEM_BYTES) begin
        index = (addr >> 2);
        instr = mem[index];
    end
    else begin
        instr = 32'hDEADBEEF; //illegal reading
    end
end

endmodule