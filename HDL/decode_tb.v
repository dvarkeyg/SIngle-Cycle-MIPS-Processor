`define MEM_START 32'h8002_0000
`define FILE_TO_CHECK "mips-benchmarks/SumArray.x"
// `include "memory.v"
// `include "decode.v"

module decode_tb;

  reg mem_en = 1, mem_rw = 0, dec_en;
  reg clock = 1;
  reg[31:0] program_counter = `MEM_START;
  reg[31:0] mem_input, scan_file, instr_in;

  wire[31:0] mem_output;

  integer data_file, scan,f, index = 0;

  task read_file;
    input integer file;

    while(!$feof(file))
    begin
      scan = $fscanf(file, "%h\n", scan_file);
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

  decoder decoder
  (
    .instruction(instr_in),
    // .clk(clock),
    .en(dec_en),
    .rs(),
    .rt(),
    .rd(),
    .im(),
    .func(),
    .instr_idx(),
    .base(),
    .offset()
  );

  always begin
    #5 clock = ~clock;
  end

  initial begin

    $dumpfile("decode_tb.vcd");
    $dumpvars(0,decode_tb);
    data_file = $fopen(`FILE_TO_CHECK, "r");

    $display("Using data in file: %s", `FILE_TO_CHECK);
    read_file(data_file);

    #10  mem_rw = 1;
        dec_en = 1;
    #10 program_counter = `MEM_START;


    while(index != 0) begin

      instr_in = mem_output;
      $display("PC: %h",program_counter);

      #10 program_counter = program_counter + 4;

      index = index - 1;
    end

     #10 $finish;
  end

endmodule
