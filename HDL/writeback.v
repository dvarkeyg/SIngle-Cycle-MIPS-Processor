module writeback
(
	input wire mem_op,
	input wire[31:0] data_mem_out,
	input wire[31:0] alu_out,
	input wire	enable,

	output reg[31:0] writeback_out
);

//wire[31:0] out;
always @(*) begin
	if(enable ==1) begin
		if(mem_op == 1) begin
			writeback_out = data_mem_out;
		end
		else begin
			writeback_out = alu_out;
		end
	end
end

//assign writeback_out = out;

endmodule
