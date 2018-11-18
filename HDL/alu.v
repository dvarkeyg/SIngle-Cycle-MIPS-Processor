`define sll 6'b000000
`define srl 6'b000010
`define sra 6'b000011
`define sllv 6'b000100
`define srlv 6'b000110
`define srav 6'b000111
`define mfhi 6'b010000
`define mflo 6'b010010
`define mult 6'b011000
`define mul 6'b011100
`define multu 6'b011001
`define div 6'b011010
`define divu 6'b011011
`define add 6'b100000
`define addu 6'b100001
`define sub 6'b100010
`define subu 6'b100011
`define and 6'b100100
`define or 6'b100101
`define xor 6'b100110
`define nor 6'b100111
`define slt 6'b101010
`define sltu 6'b101011
`define addi 6'b001000
`define addiu 6'b001001
`define slti 6'b001010
`define sltiu 6'b001011
`define ori 6'b001101
`define xori 6'b001110
`define lui 6'b001111
`define lb 6'b100000
`define lw 6'b100011
`define lbu 6'b100100
`define sb 6'b101000
`define sw 6'b101011

//`include "sign_extend.v"

module alu
  (
    input   wire                 clock,
    input   wire [31:0]          in_s1,
    input   wire [31:0]          in_s2,
    //input   wire [31:0]		       pc,
    input   wire [4:0]           sa,
    input   wire [5:0]           alu_opcode,
    input   wire [15:0]          imm_val,
    input wire 			 enable,

    input   wire                 nop,
    input   wire                 mem_op,

    input   wire                 sign_x,

    output  reg [31:0]           out
  );

  wire [31:0] imm_val_32;
  wire signed [31:0] signed_in_s1;
  wire signed [31:0] signed_in_s2;
  wire signed [31:0] signed_imm_val_32;

  reg[63:0] hi_lo = 0;
  reg[63:0] hi_lo_f = 0;



  // always @ (posedge clock) begin
  //   if(alu_opcode == `mult || alu_opcode == `multu || alu_opcode == `div || alu_opcode == `divu) begin
  //     hi_lo_f <= hi_lo;
  //   end
  // end

  sign_extender sign_extender
  (
    .imm_val(imm_val),
    .ctrl(sign_x),
    .out_val(imm_val_32)
  );


  assign signed_in_s1         = in_s1;
  assign signed_in_s2         = in_s2;
  assign signed_imm_val_32    = imm_val_32;

  always @ (*) begin
  #1
    if(enable == 1) begin
      if (nop != 1) begin
      //  $display("in_s1 = %h, in_s2 = %h", in_s1, in_s2);
          case(alu_opcode)
        	 	`sll: begin
        		   out = in_s2 << sa;
        	   end
        	  `srl: begin
        	     out = in_s2 >> sa;
        		end
        		`sra: begin
        		   out = in_s2 >>> sa;
        		end
        		`sllv: begin
        		   out = in_s2 << in_s1[4:0];
        		end
        		`srlv: begin
        		   out = in_s2 >> in_s1[4:0];
        		end
        		`srav: begin
        			 out = in_s2 >>> in_s1[4:0];
        		end
        		`mfhi: begin
        			 out = hi_lo[63:32];
        		end
        		`mflo: begin
        			 out = hi_lo[31:0];
        		end
        		`mult: begin
        			 hi_lo[31:0] = signed_in_s1 * signed_in_s2;
        		end
            `mul: begin
                out = signed_in_s1 * signed_in_s2;
            end
            `multu: begin
        			   hi_lo[31:0] = signed_in_s1 * signed_in_s2;
        		end
            	`div: begin
                //hi_lo[31:0] = signed_in_s1 + 1; changed it here to check the waveforms.
        			 hi_lo[31:0] = signed_in_s1 / signed_in_s2;
               hi_lo[63:32] = signed_in_s1 % signed_in_s2;
               $display("HI_LO: %h", hi_lo);
             	end
          	`divu: begin
        			 hi_lo[31:0] = in_s1 / in_s2;
               hi_lo[63:32] = in_s1 % in_s2;
               //$display("HI_LO: %h", hi_lo);
        		end
        		`addu: begin
        	     out = signed_in_s1 + signed_in_s2 ;
        		end
        		`sub: begin
        		   out = signed_in_s1 - signed_in_s2;
        		end
        		`or: begin
        		   out = in_s1 | in_s2;
        		end
        		`xor: begin
        		   out = in_s1 ^ in_s2;
        		end
        		`nor: begin
        			 out = !(in_s1 | in_s2);
        		end
        		`slt: begin
        			if(signed_in_s1 < signed_in_s2) begin
        				out = 1;
        			end
        			else begin
        				out = 0;
        			end
        		end
        		`addi: begin
        			out = signed_in_s1 + signed_imm_val_32;
        		end
        		`addiu: begin
        	    out = signed_in_s1 + signed_imm_val_32;
        		end
        		`slti: begin
        	    if(signed_in_s1 < signed_imm_val_32) begin
        				out = 1;
        			end
        			else begin
        				out = 0;
        			end
        		end
        		`sltiu: begin
        	    if(in_s1 < in_s2) begin
        				out = 1;
        			end
        			else begin
        				out = 0;
        			end
        		end
        		`ori: begin
        			out = in_s1 | imm_val_32;
        		end
        		`xori: begin
        		       	out = in_s1 ^ imm_val_32;
        		end
        		`lui: begin
        		       	out = imm_val << 16;
        		end
  		//lb and add
        		6'b100000: begin
  			      if( mem_op) begin
        				out = signed_in_s1 + signed_imm_val_32;
  			      end
  			      else begin
  				      out = signed_in_s1 + signed_in_s2;
  			      end
        		end
  		//lw and subu
        		`lw: begin
  			      if(mem_op) begin
        				out = signed_in_s1 + signed_imm_val_32;
  			      end
  			      else begin
  				      out = signed_in_s1 - signed_in_s2;
  			      end
        		end
  		//lbu and and
        		`lbu: begin
  			       if(mem_op) begin
        				out = signed_in_s1 + imm_val_32;
  			       end
  			       else begin
  				      out = in_s1 & in_s2;
  			       end
        		end
        		`sb: begin
        			out = signed_in_s1 + signed_imm_val_32;
        		end
  		//sw and sltu
        		`sw: begin
  			if(mem_op) begin
        	       			out = signed_in_s1 + signed_imm_val_32;
  			end
  			else begin
  				if(in_s1 < in_s2) begin
  					out = 1;
  				end
  				else begin
  					out = 0;
  				end
  			end
        		end

                default: begin
                  $display("invalid");
                  //hi_lo <= hi_lo;
                end

        endcase
    //  $display("out: %h",out);
      end
    end
  end
  endmodule
