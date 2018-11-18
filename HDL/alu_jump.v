`define jr 6'b001000
`define jal 6'b000011
`define jalr 6'b001001
`define j 6'b000010

module alu_jump
(
	input wire [31:0]			pc,
	input wire [31:0]     register,
	input wire [25:0]			target,
	input wire [5:0] 			alu_opcode,
	input wire				nop,
	input wire				enable,

	output reg [31:0]			out_pc
//	output reg [31:0]			reg31
);

always @(*) begin
    if(enable == 1) begin
	if(!nop) begin
	case(alu_opcode)
		`j: begin
			out_pc = ((pc & 32'hf0000000) | (target<<2));
		end
		`jr: begin
			out_pc = register;
		end
		`jal: begin
			out_pc = ((pc & 32'hf0000000) | (target << 2));
		end
		`jalr: begin
			out_pc = register;
		end

		default: $display("not a jump");
	endcase
end
end
end
endmodule
