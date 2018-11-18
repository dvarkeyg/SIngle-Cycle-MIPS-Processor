`define MEM_START 32'h8000_2000
`define FILE_TO_CHECK "../mips-benchmarks/SumArray.x"
`include "memory.v"

module mem_tb;

  reg mem_en = 1, mem_rw = 0;
  reg clock = 1;
  reg[31:0] program_counter = `MEM_START;
  reg[31:0] mem_input, scan_file;

  wire[31:0] mem_output;
  wire busy;

  integer data_file, scan,f;
  integer index = 0;
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


  task test_file;
    input integer file;

    while(!$feof(file))
    begin
      scan = $fscanf(file, "%h\n", scan_file);
      mem_input = scan_file;
      mem_rw = 0;
      #10 mem_rw = 1;

      #10 $display("address: %h, data_in: %h, data_out: %h\n", program_counter, scan_file, mem_output);
          if(scan_file != mem_output)
        begin
          $display("input not equal to output, error in address:%h\n", program_counter);
        end

          program_counter = program_counter + 4;
    end
  endtask

  always begin
    #5 clock = ~clock;
  end

  initial begin
    $dumpfile("main_mem_tb.vcd");
    $dumpvars(0,mem_tb);
    data_file = $fopen(`FILE_TO_CHECK, "r");
    $display("Using data in file: %s", `FILE_TO_CHECK);
    test_file(data_file);
    $display("Testing enable.");
    program_counter = 32'h8002_0000;

    #10 mem_en = 0;
        mem_rw = 0;
    #10 mem_input = 32'hFFFF_FFFF;
    #10 $display("data_in = %h, data_out = %h, enable = %b, read_write = %b\n", mem_input, mem_output, mem_en, mem_rw);

    #10 mem_en = 1;
        mem_rw = 1;
    #10 $display("data_in = %h, data_out = %h, enable = %b, read_write = %b\n", mem_input, mem_output, mem_en, mem_rw);

    $finish;
  end
endmodule
