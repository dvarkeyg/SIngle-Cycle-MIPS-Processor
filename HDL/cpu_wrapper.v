// `include "memory.v"
// `include "decode_wrapper.v"
// `include "execute_wrapper.v"
// `include "writeback.v"
// `include "sign_extend.v"

module cpu
(
	input  wire[31:0] 			pc,
	input  wire 						clock,
	input  wire[31:0] 			mem_input,
	input  wire 						enable,
	input  wire 						mem_rw,
	output wire[31:0] 			out_pc,
	output wire[31:0] 			stack_pointer
);

wire alu_b, rwe, dec_en, d_mem_we;
wire br, jp, mem_op, nop, g_t, sign_x, zero, busy, access_size, byte_s, link;

wire[4:0] rs, rt, rd, sa;
wire[5:0] alu_op;
wire[15:0] immediate;
wire[25:0] j_target;
wire[31:0] s1, s2, mem_output, instruction, out_val, data_mem_out, data_in;

wire[31:0] write_back_mem_in;
memory main_mem
(
	.clock(clock),
	.address(pc),
	.data_in(mem_input),
	.read_write(mem_rw),
	.enable(1'b1),
	.data_out(mem_output),
	.busy(busy)
);

assign instruction = mem_output;

decode decode
(
	.pc(pc),
	.instruction(instruction),
	.dec_en(enable),
	.data_in(data_in),

	.clk(clock),
	.out_s1(s1),
	.out_s2(s2),
	.sa(sa),
	.im(immediate),
	.base(rs),
	.j_target(j_target),
	.alu_in_b(alu_b),
	.alu_op(alu_op),
	.link(link),

	.access_size(access_size),
	.byte_s(byte_s),

	.rwd(rwe),
	.d_mem_we(d_mem_we),
	.br(br),
	.jp(jp),
	.g_t(g_t),
	.sign_x(sign_x),
	.nop(nop),
	.mem_op(mem_op),
	.stack_pointer(stack_pointer)
);

execute execute
(
	.clock(clock),
	.pc(pc),
	.in_s1(s1),
	.in_s2(s2),
	.sa(sa),
	.im(immediate),
	.offset(immediate),
	.instr_idx(j_target),
	.alu_op(alu_op),
	.enable(enable),

	.br(br),
	.jp(jp),
	.mem_op(mem_op),
	.g_t(g_t),
	.nop(nop),
	.sign_x(sign_x),
	.link(link),

	.zero(zero),
	.out_val(out_val),
	.out_pc(out_pc)
);

data_mem_wrapper data_mem
(
	.clock(clock),
	.address(out_val),
	.data_in(s2),

	.read_write(d_mem_we),
	.enable(mem_op),
	.access_size(access_size),
	.byte_s(byte_s),

	.data_mem_out(write_back_mem_in),
	.busy(busy)
);

writeback writeback
(
	.mem_op(mem_op),
	.enable(enable),
	.data_mem_out(write_back_mem_in),
	.alu_out(out_val),
	.writeback_out(data_in)
);

endmodule
