`define MEM_DEPTH 262144
`define MEM_START 32'h8002_0000

module reg_file
  (
    //source address
    input wire[4:0]        address_s1,
    input wire[4:0]        address_s2,
    //destination address
    input wire[4:0]         address_d,

    //data input for writing to file
    input wire[31:0]        data_dval,


    //output wires for combinational reads
    output wire[31:0]       data_s1val,
    output wire[31:0]       data_s2val,
    output wire[31:0] 	    stack_pointer,

    //control signals for clk and read/write
    input  wire             write_enable,
    input  wire             clock

  );

  //special purpose HI and LO registers used in multiplication and division

  //instantiate register file as an array of registers
  reg[31:0] reg_array [31:0];

  integer i, x;
  initial begin
    for(i = 0; i < 32; i=i+1)
      reg_array[i] = i;

    reg_array[29] = `MEM_START + `MEM_DEPTH;
    for(i = 0; i < 32; i=i+1)
      $display("reg %d: %h",i,reg_array[i]);
  end

  always @( posedge clock) begin
  for(i = 0; i < 32; i=i+4)
    $display("reg %2d: %h, reg %2d: %h, reg %2d: %h, reg %2d: %h",
    i,reg_array[i], i+1,reg_array[i+1], i+2,reg_array[i+2], i+3,reg_array[i+3]);
  end
  //latches for output ports
  reg [31:0] out_1_q, out_2_q;

  //combinational logic assigned to output wires
  // assign data_s1val = out_1_q;
  // assign data_s2val = out_2_q;
  assign data_s1val = reg_array[address_s1];
  assign data_s2val = reg_array[address_s2];
  assign stack_pointer = reg_array[29];

  //sensitivity list that checks for if read and assigns outputs
  // always @ (*) begin
  //   if(!write_enable) begin
  //     out_1_q <= reg_array[address_s1];
  //     out_2_q <= reg_array[address_s2];
  //
  //   end
  // end

  //writes should only be associated with clk edges
  always @ (posedge clock)
  begin
    //write is active high
    if(write_enable) begin
      //discard writes to register 0
      if(address_d != 5'b0) begin
        //case where register file is written to in any other situation
          reg_array[address_d] <= data_dval;
      end
    end
  end

endmodule
