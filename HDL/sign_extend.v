module sign_extender
  (
    input wire  [15:0]   imm_val,
    input wire           ctrl,

    output wire [31:0]   out_val
  );

  wire extend_bit;

  //zero extended if ctrl is not set to 1
  assign extend_bit       = (ctrl == 1) ? imm_val[15] : 1'b0;

  //based on the bit to be extended
  assign out_val           = {{16{extend_bit}}, imm_val};

endmodule
