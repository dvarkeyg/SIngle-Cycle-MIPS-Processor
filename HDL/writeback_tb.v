`define MEM_START 32'h8002_0000
`define FILE_TO_CHECK "demo2018/DemoDoom2018.x"
`define MEM_END 32'hfffff
 // `include "cpu_wrapper.v"
module writeback_tb;

  reg clock = 1;
  reg mem_rw = 0, enable=0;
  reg[31:0] program_counter = `MEM_START;
  //reg file_nop=0,file_write=0;
  reg[31:0] scan_file,mem_input;

  wire[31:0] out_pc;

  reg[31:0] orig_stack_pointer = `MEM_END;
  wire[31:0] stack_pointer;

  integer data_file,scan,f,index = 0;



  task read_file;
	  input integer file;

	  while(!$feof(file))
  begin
	  scan = $fscanf(file, "%h\n",scan_file);
	  // #10 mem_input = scan_file;
    cpu.main_mem.mem_array[index] = scan_file;
    cpu.data_mem.mem.mem_array[index] = scan_file;
	  //program_counter = program_counter + 4;
	  index = index + 1;
  end
  endtask

cpu cpu
(
	.pc(program_counter),
	.mem_input(mem_input),
	.clock(clock),
	.enable(enable),
	.mem_rw(mem_rw),
	.out_pc(out_pc),
	.stack_pointer(stack_pointer)
);

always begin
	#5 clock = ~clock;
end

initial begin
	$dumpfile("writeback_tb.vcd");
	$dumpvars(0,writeback_tb);
	data_file = $fopen(`FILE_TO_CHECK,"r");

	$display("using data in file : %s",`FILE_TO_CHECK);

	read_file(data_file);
  orig_stack_pointer = stack_pointer;

	#10 //program_counter = out_pc;
	    mem_rw = 1;
	    enable = 1;
	    $display("PROGRAM STARTING");
  #10  program_counter = out_pc;
  #10
	while(stack_pointer != orig_stack_pointer) begin
	  $display("pc: %h",program_counter);
	  #10 program_counter = out_pc;
	end

       $display("test done");
	$finish;
end

// always @ (posedge clock)
//   if(enable == 1) begin
//     if(stack_pointer != orig_stack_pointer) begin
//       $display("pc: %h",program_counter);
//       program_counter = out_pc;
//     end else begin
//       $finish;
//     end
//   end
endmodule
