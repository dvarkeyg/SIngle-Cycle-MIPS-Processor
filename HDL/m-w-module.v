module m-w
(
	input wire		clock,
	input wire [31:0]	pc,
	input wire [31:0]	instr_in,
	input wire [31:0]	mem_data_in,
	input wire [31:0]	mem_address_in,
	input wire		mem_op_in,
	input wire		wb_enable_in,

	input wire		enable,

	output reg [31:0]	out_pc,
	output reg [31:0]	instr_out
	output reg [31:0]	mem_data_out,
	output reg [31:0]	mem_address_out,
	output reg		mem_op_out,
	output reg		wb_enable_out
)

always(posedge clock) begin
	if(enable == 1) begin
		out_pc <= pc;
		instr_out <= instr_in;
		mem_data_out <= mem_data_in;
		mem_address_out <= mem_address_in;
		busy_out <= busy_in;
		mem_op_out <= mem_op_in;
		wb_enable_out <= wb_enable_in;
	end
end
endmodule
