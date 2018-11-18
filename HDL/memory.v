`define MEM_DEPTH 262144
`define MEM_START 32'h8002_0000

module memory
  (
    input   wire                clock,
    input   wire[31:0]          address,
    input   wire[31:0]          data_in,
    input   wire                read_write,
    input   wire                enable,
    output  wire[31:0]          data_out,
    output  wire                busy
    );

    reg[31:0] mem_array [`MEM_DEPTH-1:0];
    integer index;

    always @ (*)
    begin
      index = (address - `MEM_START) >> 2;
    end

    assign data_out = (enable && read_write) ? mem_array[index] : 32'b0;
    assign busy = enable && read_write;

    always @ (posedge clock)
    begin
      if (enable)
      begin
        if(!read_write)
        begin
          $display("Address: %h, data: %h", address, data_in);
          mem_array[index] <= data_in;
          //$display("%d :%d\n",$time, address - `MEM_START >> 2);
        end
      end
    end
endmodule
