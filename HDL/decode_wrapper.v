// `include "decode.v"
// `include "reg_file.v"
module decode
  (
    input  wire [31:0]        pc,
    input  wire [31:0]        instruction,

    input  wire               clk,
    input  wire		            dec_en,
    input  wire [31:0]	        data_in,

    output wire [31:0]        out_s1,
    output wire [31:0]        out_s2,
    output wire [4:0]         sa,
    output wire [15:0]        im,

    output wire [4:0]         base,
    output wire [25:0]        j_target,
    output wire [5:0]         alu_op,

    output wire               access_size,
    output wire               byte_s,
    output wire               alu_in_b,
    output wire               d_mem_we,
    output wire               rwd,
    output wire               br,
    output wire               jp,
    output wire               g_t,
    output wire               sign_x,
    output wire               nop,
    output wire               mem_op,
    output wire               link,
    output wire [31:0] 	      stack_pointer
  );


  wire [4:0]           rs;
  wire [4:0]           rt;
  wire [4:0]           rd;

  wire [4:0]           s1_addr;
  wire [4:0]           dest_addr;
  wire [31:0]          data_s1val;
  wire [31:0]          data_s2val;

  wire                 r_dst;
  wire 		             rwe;

  decoder decoder
  (
      .instruction(instruction),
      .en(dec_en),
      .rs(rs),
      .rt(rt),
      .rd(rd),
      .sa(sa),
      .im(im),
      .base(base),
      .j_target(j_target),
      .alu_op(alu_op),
      .rwe(rwe),
      .r_dst(r_dst),
      .access_size(access_size),
      .byte_s(byte_s),
      .link(link),
      .alu_in_b(alu_in_b),
      .d_mem_we(d_mem_we),
      .rwd(rwd),
      .br(br),
      .jp(jp),
      .g_t(g_t),
      .sign_x(sign_x),
      .nop(nop),
      .mem_op(mem_op)
  );
  assign dest_addr = (link ==1) ? 5'b11111: (r_dst == 1) ? rd : rt;
  assign s1_addr = (mem_op == 1) ? base : rs;

  reg_file register_file
  (
    .clock(clk),
    .address_s1(s1_addr),
    .address_s2(rt),

    .address_d(dest_addr),
    .data_dval(data_in),

    .data_s1val(data_s1val),
    .data_s2val(data_s2val),
    .stack_pointer(stack_pointer),

    .write_enable(rwe)
  );

  assign out_s1 = data_s1val;
  assign out_s2 = data_s2val;
endmodule
