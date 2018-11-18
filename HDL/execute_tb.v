`define MEM_START 32'h8002_0000
`define FILE_TO_CHECK "mips-benchmarks/SumArray.x"
// `include "memory.v"
// `include "execute_wrapper.v"
// `include "decode_wrapper.v"
// `include "sign_extend.v"
module execute_tb;

  reg clock = 1;
  reg[31:0] program_counter = `MEM_START;
  reg mem_en=1,mem_rw=0,dec_en=0;
  reg file_nop=0,file_write=0;
  reg[31:0] mem_input,scan_file,instr_in;

  wire alu_b, nop, rwe;
  wire[5:0] alu_op;
  wire[4:0] rs, rt, rd;
  wire[15:0] imm;
  wire[25:0] j_target;
  wire[31:0] mem_output;

  wire[4:0] sa;
//  wire [15:0] offset;
  wire[31:0] in_s1, in_s2, out_pc, out_val;

  wire br,jp,g_t,sign_x,mem_op,zero;

  integer data_file,scan,f,index = 0;



  task read_file;
	  input integer file;

	  while(!$feof(file))
  begin
	  scan = $fscanf(file, "%h\n",scan_file);
	  #10 mem_input = scan_file;
	  #10 program_counter = program_counter + 4;
	  index = index + 1;
  end
  endtask

memory main_mem
(
	.clock(clock),
	.address(program_counter),
	.data_in(mem_input),
	.read_write(mem_rw),
	.enable(mem_en),
	.data_out(mem_output),
	.busy(busy)
);

decode decode
(
	.pc(program_counter),
	.instruction(instr_in),
	.clk(clock),
	.out_s1(in_s1),
	.out_s2(in_s2),
	.sa(sa),
	.im(imm),
	.base(rs),
	.j_target(j_target),
	.alu_op(alu_op),
	.rwe(rwe),
	.alu_in_b(alu_b),
	.rwd(),
	.br(br),
	.jp(jp),
	.g_t(g_t),
	.sign_x(sign_x),
	.nop(nop),
	.mem_op(mem_op)
);

execute execute
(
	.in_s1(in_s1),
	.in_s2(in_s2),
	.im(imm),
	.offset(imm),
	.pc(program_counter),
	.sa(sa),
	.instr_idx(j_target),

	.alu_op(alu_op),
	.br(br),
	.jp(jp),
	.g_t(g_t),
	.sign_x(sign_x),
	.nop(nop),
	.mem_op(mem_op),

	.zero(zero),
	.out_val(out_val),
	.out_pc(out_pc)
);

always begin
	#5 clock = ~clock;
end

initial begin
	$dumpfile("execute_tb.vcd");
	$dumpvars(0,execute_tb);
	data_file = $fopen(`FILE_TO_CHECK,"r");

	$display("using data in file : %s",`FILE_TO_CHECK);

	read_file(data_file);

	#10 mem_rw = 1;
	    dec_en = 1;

	#10 program_counter = `MEM_START;

	while(index != 0) begin
		instr_in = mem_output;
		if(br == 1 && !nop) begin
			$display("pc: %h effective address: %h branch taken: %b",out_pc,out_val,zero);
		end
		else if(jp == 1& !nop) begin
			$display("pc: %h effective address: %h",out_pc,out_val);
		end
		else if(!nop & mem_op ==1) begin
			$display("effective address: %h",out_val);
		end
		else if(nop) begin
			$display("nop");
		end
		else begin
			$display("computed value: %h",out_val);
		end

		#10 program_counter = program_counter+4;
		index = index-1;
	end
	#10 $finish;
end
endmodule
