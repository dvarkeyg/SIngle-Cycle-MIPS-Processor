`define blez 6'b000110
`define bgtz 6'b000111

//`include "sign_extend.v"

module alu_branch
(
	input wire [5:0] 	alu_opcode,
	input wire [31:0]	in_s1,
	input wire [31:0]	in_s2,
	input wire [15:0]	offset,
	input wire [31:0] 	pc,
	input wire 		g_t,
	input wire		nop,
	input wire		enable,



	output reg 		zero,
	output reg [31:0] 	out_pc
);

wire [31:0]  offset_ext;

sign_extender sign_extender
(
	.imm_val(offset),
	.ctrl(1'b1),
	.out_val(offset_ext)
);

always @(*) begin
  if(enable == 1) begin
	if(!nop) begin
	case(alu_opcode)
		 6'b000001: begin
		 if (g_t == 1) begin
		 		zero = (in_s1 >= 0) ? 1 : 0 ;
			end else begin
				zero = (in_s1 < 0) ? 1 : 0 ;
			end
			out_pc = pc + 4 + (offset_ext << 2);
		end
		6'b000100: begin
			if(in_s1 == in_s2) begin
				zero = 1;
			end
			else begin
				zero = 0;
			end
			out_pc = pc + 4 + (offset_ext << 2);
		end
		6'b000101: begin
			if(in_s1 != in_s2) begin
				zero = 1;
			end
			else begin
				zero = 0;
			end
			out_pc = pc + 4 + (offset_ext << 2);
		end
		`blez: begin
			if(in_s1 <= 0) begin
				zero = 1;
			end
			else begin
				zero = 0;
			end
			out_pc = pc + 4 + (offset_ext << 2);
		end
		`bgtz: begin
			if(in_s1 > 0) begin
				zero = 1;
			end
			else begin
				zero = 0;
			end
			out_pc = pc + 4 + (offset_ext << 2);
		end

		default: $display("not a branch");
	endcase

	//out_pc = pc + offset_ext;
end
end
end
endmodule
