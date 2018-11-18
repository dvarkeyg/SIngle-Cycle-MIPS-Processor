`define MEM_DEPTH 262144
`define MEM_START 32'h8002_0000

module data_memory
  (
    input   wire                clock,
    input   wire[31:0]          address,
    input   wire[31:0]          data_in,

    input   wire                access_size,
    input   wire                byte_s,
    input   wire                read_write,
    input   wire                enable,

    output  wire[31:0]          data_out,
    output  wire                busy
    );

    reg[31:0] mem_array [`MEM_DEPTH-1:0];
    reg flag_array[`MEM_DEPTH-1:0];
    wire integer index;

    integer i, x;

    initial begin
      for(i = 0; i < `MEM_DEPTH; i=i+1)
        flag_array[i] = 0;
    end


    // always @ (*)
    // begin
    //   index = (address - `MEM_START) >> 2;
    // end

    assign index = (address - `MEM_START) >> 2;
    assign data_out = (enable == 1) ? mem_array[index]:32'bz;
    assign busy = enable && !read_write;

    always @ (posedge clock)
    begin
      for(i = 0; i < `MEM_DEPTH; i=i+1) begin
        if (flag_array[i] == 1) begin
          $display("Data Mem index: %d, data: %h", i, mem_array[i]);
        end
      end
    end

    always @ (posedge clock)
    begin
      if (enable == 1)
      begin
        if(read_write == 1)
        begin
          if(access_size == 1) begin
            flag_array[i] = 1;
            case(address[1:0])
              2'b00:    mem_array[index][31:24]     <= data_in[7:0];
              2'b01:    mem_array[index][23:16]    <= data_in[7:0];
              2'b10:    mem_array[index][15:8]   <= data_in[7:0];
              2'b11:    mem_array[index][7:0]   <= data_in[7:0];
              default:  $display("Invalid address");
            endcase
          end else begin
            mem_array[index] <= data_in;
            flag_array[index] <= 1;
         end
          $display("%d :%d\n",$time, address - `MEM_START >> 2);
      end
      end
    end
endmodule
