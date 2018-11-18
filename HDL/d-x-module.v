module d-x
(
	input wire		clock,
	input wire [31:0]	instr_in,
	input wire [31:0]	pc,
	input wire [31:0]	s1_in,
	input wire [31:0]	s2_in,

	input wire [15:0]	offset_in,
	input wire		br_in,
	input wire		jp_in,
	input wire		mem_op_in,
	input wire		g_t_in,
	input wire [4:0] 	sa_in,
	input wire [15:0]	imm_in,
	input wire [5:0]	alu_op_in,
	input wire		sign_x_in,
	input wire		execute_enable_in,
	input wire		link_in,

	input wire 		enable,

	output reg [31:0]	out_pc,
	output reg [31:0]	instr_out,
	output reg [31:0]	s1_out,
	output reg [31:0]	s2_out,

	output reg [15:0]	offset_out,
	output reg		br_out,
	output reg		jp_out,
	output reg		mem_out_out,
	output reg		g_t_out,
	output reg [4:0]	sa_out,
	output reg [15:0]	imm_out,
	output reg [5:0]	alu_op_out,
	output reg		sign_x_out,
	output reg		execute_enable_out,
	output reg		link_out,
)


always(posedge clock) begin
	if(enable == 1) begin
		out_pc <= pc;
		instr_out <= instr_out;
		s1_out <= s1_in;
		s2_out <= s2_in;
		offset_out <= offset_in;
		br_out <= br_in;
		jp_out <= jp_in;
		mem_op_out <= mem_op_in;
		g_t_out <= g_t_in;
		sa_out <= sa_in;
		alu_op_out <= alu_op_in;
		sign_x_out <= sign_x_in;
		execute_enable_out <= execute_enable_in;
		link_out <= link_in;
		zero_out <= zero_in;
	end
end
endmodule
