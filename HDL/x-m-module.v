module x-m-module
(
	input wire		clock,
	input wire [31:0] 	pc,
	input wire [31:0]	instr_in,
	input wire [31:0]	address_in,
	input wire [31:0] 	data_in,

	input wire		mem_read_write_in,
	input wire		mem_enable_in,

	input wire		enable,

	output reg [31:0]	instr_out,
	output reg [31:0]	out_pc,
	output reg [31:0]	data_out,
	output reg [31:0]	address_out,
	output reg		mem_read_write_out,
	output reg		mem_enable_out
)

always(posedge clock) begin
	if(enable == 1) begin
		out_pc <= pc;
		instr_out <= instr_in;
		address_out <= address_in;
		data_out <= data_in;
		mem_read_write_out <= mem_read_write_in;
		mem_enable_out <= mem_enable_in;
	end
end
endmodule
