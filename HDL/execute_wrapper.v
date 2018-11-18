// `include "alu.v"
// `include "alu_branch.v"
// `include "alu_jump.v"
module execute
  (
    input  wire               clock,
    input  wire [4:0]         sa,
    input  wire [15:0]        im,

    input  wire [25:0]        instr_idx,
    input  wire [5:0]         alu_op,

    input  wire               br,
    input  wire               jp,
    input  wire               g_t,
    input  wire               sign_x,
    input  wire               nop,
    input  wire               mem_op,
    input  wire		            enable,
    input  wire               link,

    input wire [31:0]	        in_s1,
    input wire [31:0] 	      in_s2,
    input wire [15:0]	        offset,
    input wire [31:0]	        pc,

    output wire [31:0]        out_pc,
    output wire               zero,

    output wire [31:0]        out_val
  );

  wire [31:0] br_out_pc, jp_out_pc, temp_out_val;

alu alu
(
  .clock(clock),
	.in_s1(in_s1),
	.in_s2(in_s2),
	.sa(sa),
	.enable(enable),
	.alu_opcode(alu_op),
	.imm_val(im),
	.nop(nop),
  .mem_op(mem_op),
	.sign_x(sign_x),
	.out(temp_out_val)
);

alu_branch alu_branch
(
	.alu_opcode(alu_op),
	.in_s1(in_s1),
	.in_s2(in_s2),
	.offset(offset),
	.enable(enable),
	.pc(pc),
	.g_t(g_t),
	.zero(zero),
	.out_pc(br_out_pc),
	.nop(nop)
);

alu_jump alu_jump
(
	.pc(pc),
	.enable(enable),
	.target(instr_idx),
  .register(in_s1),
	.alu_opcode(alu_op),
	.out_pc(jp_out_pc),
	.nop(nop)
);

assign out_pc = (nop != 1) ? (br == 1 && zero) ? br_out_pc : (jp == 1) ? jp_out_pc : pc + 4 : pc + 4 ;
assign out_val = (link == 1) ? pc + 4 : temp_out_val;

always @(*) begin
  if(!nop) begin
  	if(br == 1) begin
  		$display("branch taken?: %h ", zero);
  		$display("pc: %h ", br_out_pc);
  		$display("effective address: %h\n", out_pc);
  	end
  	else if(jp == 1) begin
  		$display("effective address: %h ",out_pc);
  		$display("pc: %h ",jp_out_pc);
  	end
  	else if(mem_op == 1) begin
  		$display("effective address: %h ", out_val);
  	end
  	else begin
  		$display("computed result: %h\n", out_val);
  	end

 end
end

endmodule
