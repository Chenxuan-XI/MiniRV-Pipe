package minirv_types;

  // ---- instruction field slices ----
  localparam int INSTR_W = 32;
  localparam int XLEN = 32;

  localparam int OPCODE_HI = 31;
  localparam int OPCODE_LO = 28;
  
  localparam int RD_HI = 27;
  localparam int RD_LO = 23;

  localparam int RS1_HI = 22;
  localparam int RS1_LO = 18;

  localparam int RS2_HI = 17;
  localparam int RS2_LO = 13;

  localparam int IMM_HI = 12;
  localparam int IMM_LO = 0;

  // ---- opcode definition ----
  typedef enum logic [3:0] {
    OP_ADD   = 4'h0,
    OP_SUB   = 4'h1,
    OP_AND   = 4'h2,
    OP_ADDI  = 4'h3,
    OP_LOAD  = 4'h8,
    OP_STORE = 4'h9
  } opcode_t;

    // ---- ALU operation definition ----
  typedef enum logic [2:0] {
    ALU_ADD = 3'b001,
    ALU_SUB = 3'b010,
    ALU_AND = 3'b011,
    ALU_NOP = 3'b111
  } alu_op_t;

  // ---- control signals bundle ----
  typedef struct packed {
    logic reg_write;
    logic is_load;
    logic is_store;
  } ctrl_t;

  //enum: choose only one case among multiple choices
  //struct: a set of all cases
  //packed: take the variable in struct as a consistent bit vector

  // ---- IF/ID pipeline bundle ----
  typedef struct packed {
    logic [XLEN-1:0]   pc;
    logic [INSTR_W-1:0] instr;
  } if_id_t;

    // ---- ID/EX pipeline bundle ----
  typedef struct packed {
    logic [XLEN-1:0] rs1_val;
    logic [XLEN-1:0] rs2_val;
    logic [4:0]      rd;

    logic [XLEN-1:0] imm;     // sign-extended imm

    alu_op_t         alu_op;
    ctrl_t           ctrl;
  } id_ex_t;


endpackage