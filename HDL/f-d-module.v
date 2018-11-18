module f-d
(
	input wire 		clock,
	input wire [31:0]	instr_in,
	input wire [31:0]	pc,
	input wire		decode_enable_in,

	input wire		enable,

	output reg [31:0]	out_pc,
	output reg [31:0]	instr_out,
	output reg		decode_enable_out;
	/*output wire [31:0]	in_s1,
	output wire [31:0]	in_s2,
	output wire [25:0]	offset,
	output wire [15:0]	imm,
	output wire [5:0]	alu_op,
	output wire [4:0]	sa,
	output wire		br,
	output wire		zero,
	output wire		jp,
	output wire		mem_op,
	output wire		nop,
	output wire		g_t,
	output wire		sign_x,
	output wire		enable,
	output wire		link*/


)


always(posedge clock) begin
	if(enable == 1) begin
		out_pc <= pc;
		insrt_out <= insrt_in;
		decode_enable_out <= decode_enable_in;
	end
end


endmodule
