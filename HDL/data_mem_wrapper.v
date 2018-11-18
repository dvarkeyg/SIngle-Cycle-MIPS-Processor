module data_mem_wrapper (

  input wire clock,
  input wire[31:0] address,
  input wire[31:0] data_in,

  input wire read_write,
  input wire enable,
  input wire access_size,
  input wire byte_s,

  output wire [31:0] data_mem_out,
  output wire busy
);

reg   [31:0] write_back_mem_in;
wire  [31:0] mem_out;

assign data_mem_out = write_back_mem_in;

data_memory mem
(
	.clock(clock),
	.address(address),
	.data_in(data_in),

	.read_write(read_write),
	.enable(enable),
  .access_size(access_size),
  .byte_s(byte_s),

	.data_out(mem_out),
	.busy(busy)
);

always @ (*) begin
    if(enable == 1) begin
      if(access_size == 1) begin
        if(byte_s == 1) begin
          case(address[1:0])
            2'b11:    write_back_mem_in <= {{24{mem_out[7]}}, mem_out[7:0]};
            2'b10:    write_back_mem_in <= {{24{mem_out[15]}},mem_out[15:8]};
            2'b01:    write_back_mem_in <= {{24{mem_out[23]}},mem_out[23:16]};
            2'b00:    write_back_mem_in <= {{24{mem_out[31]}},mem_out[31:24]};
            default:  $display("Invalid address");
          endcase
        end else begin
          case(address[1:0])
            2'b11:    write_back_mem_in <= {{24{1'b0}}, mem_out[7:0]};
            2'b10:    write_back_mem_in <= {{24{1'b0}}, mem_out[15:8]};
            2'b01:    write_back_mem_in <= {{24{1'b0}}, mem_out[23:16]};
            2'b00:    write_back_mem_in <= {{24{1'b0}}, mem_out[31:24]};
            default:  $display("Invalid address");
          endcase
        end
      end else begin
        write_back_mem_in <= mem_out;
      end
    end
end

endmodule
