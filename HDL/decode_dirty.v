module decode_dirty(instruction);

input [31:0] instruction;
reg [5:0] op_code;
reg [5:0] lsb;
reg [4:0] param2;

always @(instruction) begin
	case(op_code)
		6'b000000:case(lsb)
				6'b000000:if(param2 == 5'b00000){
					$display("nop");}
					else{
						$display("sll");
					}
				6'b000010:$display("srl");
				6'b000011:$display("sra");
				6'b000100:$display("sllv");
				6'b000110:$display("srlv");
				6'b000111:$display("srav");
				6'b001000:$display("jr");
				6'b001001:$display("jalr");
				6'b010000:$display("mfhi");
				6'b010010:$display("mflo");
				6'b011000:$display("mult");
				6'b011001:$display("multu");
				6'b011010:$display("div");
				6'b011011:$display("divu");
				6'b100000:$display("add");
				6'b100001:$display("addu");
				6'b100010:$display("sub");
				6'b100011:$display("subu");
				6'b100100:$display("and");
				6'b100101:$display("or");
				6'b100110:$display("xor");
				6'b100111:$display("nor");
				6'b101010:$display("slt");
				6'b101011:$display("sltu");
				default:$display("default");
			endcase;
		6'b000001:case(param2)
				5'b000001:$display("bgez");
				5'b000000:$display("bltz");
				default:$display("default");
			endcase;
		6'b000010:$display("j");
		6'b000011:$display("jal");
		6'b000100:if(param2 == 5'b00001){
				$display("beqz");
			}
			else{$display("beq");}
			end
		6'b000101:if(param2 != 5'b00001){
				$display("bne");
			}
			else{
				$display("bnez");
			}
		6'b000110:$display("blez");
		6'b000111:$display("bgtz");
		6'b001000:$display("addi");
		6'b001001:$display("addiu");
		6'b001010:$display("slti");
		6'b001011:$display("sltiu");
		6'b001101:$display("ori");
		6'b001111:$display("lui");
		6'b100000:$display("lb");
		6'b100011:$display("lw");
		6'b100100:$display("lbu");
		6'b101000:$display("sb");
		6'b101011:$display("sw");
		default:$display("default");
	endcase;




endmodule
