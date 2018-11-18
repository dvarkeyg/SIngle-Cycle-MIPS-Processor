//Decoder module
module decoder
 (
		input [31:0]        instruction,
    input               en,

    output [4:0]        rs,
    output [4:0]        rt,
    output [4:0]        rd,
    output [4:0]        sa,
    output [15:0]       im,

    output [4:0]        base,
    output [25:0]       j_target,
    output [5:0]        alu_op,
    output              rwe,
    output              r_dst,
    output              alu_in_b,
    output              d_mem_we,
    output              rwd,
    output              br,
    output              jp,
    output              g_t,
    output              sign_x,
    output              nop,
    output              mem_op,
    output              access_size,
    output              byte_s,
    output              link
	);

reg                     rwe;
reg                     r_dst;
reg                     alu_in_b;
reg                     alu_op;
reg                     d_mem_we;
reg                     rwd;
reg                     br;
reg                     jp;
reg                     sign_x;
reg                     access_size;
reg                     byte_s;
reg                     link;
wire                    nop;
wire                    mem_op;
wire                    g_t;



wire [5:0]              op_code;
//For R type Instructions
wire [4:0]              rs;
wire [4:0]              rt;
wire [4:0]              rd;
wire [4:0]              sa;


//For I type Instructions/memory offset
wire [15:0]             im;

//For ALU use
wire [5:0]              func;


//For any instruction using memory
wire [4:0]              base;

//For jump Instructions
wire [25:0]             j_target;


assign op_code          = instruction[31:26];
assign rs               = instruction[25:21];
assign rt               = instruction[20:16];
assign rd               = instruction[15:11];
assign sa               = instruction[10:6];
assign im               = instruction[15:0];

assign base             = instruction[25:21];
assign offset           = instruction[15:0];
assign func             = instruction[5:0];
assign j_target         = instruction[25:0];

assign mem_op           = instruction[31];

assign nop              = (instruction == 0) ? 1 : (func == 6'b110100 && op_code == 0) ? 1 : 0;

assign g_t              = instruction[16];

always @(*) begin
if(en) begin
    $write("time: %5d, Input: %h, Instruction: ", $time, instruction);
    if(instruction == 0)
    begin
      $write(" nop\n");
    end
    else
    begin
        case(op_code)
            //R Type instruction
        		 6'b000000: begin
              d_mem_we <= 0;
              access_size <= 0;

        			case(func)
                6'b000000: begin
                  $write("sll");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 0;
                  alu_in_b  <= 1;
                  alu_op    <= 6'b0;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 1;
                  rwd       <= 1;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b000001: begin
                  if(instruction[16] == 1) begin
                    $write("movt");
                  end else begin
                    $write("movf");
                  end
                end
                6'b100000: begin
                  $write("add");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 1;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 1;
                  rwd       <= 0;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b100001: begin
                  $write("addu");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 1;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 1;
                  rwd       <= 0;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b100100: begin
                  $write("and");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 0;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 1;
                  rwd       <= 0;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b011010: begin
                  $write("div");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 1;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 0;
                  r_dst     <= 0;
                  rwd       <= 0;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b011011: begin
                  $write("divu");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 1;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 0;
                  r_dst     <= 0;
                  rwd       <= 0;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b001001: begin
                  $write("jalr");
                  br        <= 0;
                  jp        <= 1;
                  sign_x    <= 0;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 0;
                  rwd       <= 0;
                  link      <= 1;
                  byte_s    <= 0;
                end
                6'b001000: begin
                  $write("jr");
                  br        <= 0;
                  jp        <= 1;
                  sign_x    <= 0;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 0;
                  r_dst     <= 0;
                  rwd       <= 0;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b010000: begin
                  $write("mfhi");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 0;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 1;
                  rwd       <= 1;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b010010: begin
                  $write("mflo");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 0;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 1;
                  rwd       <= 1;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b011000: begin
                  $write("mult");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 0;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 0;
                  rwd       <= 0;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b011001: begin
                  $write("multu");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 0;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 0;
                  rwd       <= 0;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b100111: begin
                  $write("nor");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 0;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 1;
                  rwd       <= 0;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b100101: begin
                  $write("or");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 0;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 1;
                  rwd       <= 0;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b000100: begin
                  $write("sllv");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 0;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 1;
                  rwd       <= 1;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b101010: begin
                  $write("slt");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 0;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 1;
                  rwd       <= 0;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b101011: begin
                  $write("sltu");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 1;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 1;
                  rwd       <= 0;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b000011: begin
                  $write("sra");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 1;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 1;
                  rwd       <= 1;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b000111: begin
                  $write("srav");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 0;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 1;
                  rwd       <= 1;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b000010: begin
                  $write("srl");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 0;
                  alu_in_b  <= 1;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 1;
                  rwd       <= 1;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b000110: begin
                  $write("srlv");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 0;
                  alu_in_b  <= 1;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 1;
                  rwd       <= 1;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b100010: begin
                  $write("sub");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 0;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 1;
                  rwd       <= 0;
                  link      <= 0;
                  byte_s    <= 0;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b100011: begin
                  $write("subu");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 0;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 1;
                  rwd       <= 0;
                  link      <= 0;
                  byte_s    <= 0;
                end
                6'b100110: begin
                  $write("xor");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 0;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 1;
                  r_dst     <= 1;
                  rwd       <= 0;
                  link      <= 0;
                  byte_s    <= 0;
                end
                default: begin
                  $write("INVALID Opcode: %b, func: %b", op_code, func);
                  $write("xor");
                  br        <= 0;
                  jp        <= 0;
                  sign_x    <= 0;
                  alu_in_b  <= 0;
                  alu_op    <= func;
                  d_mem_we  <= 0;
                  rwe       <= 0;
                  r_dst     <= 0;
                  rwd       <= 0;
                  link      <= 0;
                  byte_s    <= 0;
                end
        			endcase
              $display(", rs: %h, rt: %h, rd: %h", rs, rt, rd);
           end
           6'b000001: begin
           //weird ass branch instructions
             case(rt)
                6'b00000: begin
                  $write("bltz");
                  br        <= 1;
                  jp        <= 0;
                  sign_x    <= 0;
                  alu_in_b  <= 0;
                  alu_op    <= op_code;
                  d_mem_we  <= 0;
                  rwe       <= 0;
                  r_dst     <= 0;
                  rwd       <= 0;
                  link      <= 0;
                  byte_s    <= 0;
                  access_size <= 0;
                end
                6'b00001: begin
                  $write("bgez");
                  br        <= 1;
                  jp        <= 0;
                  sign_x    <= 0;
                  alu_in_b  <= 0;
                  alu_op    <= op_code;
                  d_mem_we  <= 0;
                  rwe       <= 0;
                  r_dst     <= 0;
                  rwd       <= 0;
                  link      <= 0;
                  byte_s    <= 0;
                  access_size <= 0;
                end
                default: $write("INVALID Instruction");
             endcase
             $display(", rs: %h, offset: %h", rs, offset);
           end
           //jump instructions
           6'b000010: begin
              $display("j, index: %h", j_target);
              br        <= 0;
              jp        <= 1;
              sign_x    <= 0;
              alu_in_b  <= 0;
              alu_op    <= op_code;
              d_mem_we  <= 0;
              rwe       <= 0;
              r_dst     <= 0;
              rwd       <= 0;
              link      <= 0;
              byte_s    <= 0;
              access_size <= 0;
            end
           6'b000011: begin
              $display("jal, index: %h", j_target);
              br        <= 0;
              jp        <= 1;
              sign_x    <= 0;
              alu_in_b  <= 0;
              alu_op    <= op_code;
              d_mem_we  <= 0;
              rwe       <= 1;
              r_dst     <= 0;
              rwd       <= 0;
              link      <= 1;
              byte_s    <= 0;
              access_size <= 0;
          end
           //better branch Instructions
           6'b000100: begin
              if(rt == 1) begin
                $display("beqz, rs: %h, offset: %h", rs, offset);
                br        <= 1;
                jp        <= 0;
                sign_x    <= 0;
                alu_in_b  <= 0;
                alu_op    <= op_code;
                d_mem_we  <= 0;
                rwe       <= 0;
                r_dst     <= 0;
                rwd       <= 0;
                link      <= 0;
                byte_s    <= 0;
                access_size <= 0;
              end
              else begin
                $display("beq, rs: %h, rt: %h, offset: %h", rs, rt, offset);
                br        <= 1;
                jp        <= 0;
                sign_x    <= 0;
                alu_in_b  <= 0;
                alu_op    <= op_code;
                d_mem_we  <= 0;
                rwe       <= 0;
                r_dst     <= 0;
                rwd       <= 0;
                link      <= 0;
                byte_s    <= 0;
                access_size <= 0;
              end
           end
           //the meh kinda branch Instructions
           6'b000101: begin
              if(rt == 1) begin
                $display("bnez, rs: %h, offset: %h", rs, offset);
                br        <= 1;
                jp        <= 0;
                sign_x    <= 0;
                alu_in_b  <= 0;
                alu_op    <= op_code;
                d_mem_we  <= 0;
                rwe       <= 0;
                r_dst     <= 0;
                rwd       <= 0;
                link      <= 0;
                byte_s    <= 0;
                access_size <= 0;
              end
              else begin
                $display("bne, rs: %h, rt: %h, offset: %h", rs, rt, offset);
                br        <= 1;
                jp        <= 0;
                sign_x    <= 0;
                alu_in_b  <= 0;
                alu_op    <= op_code;
                d_mem_we  <= 0;
                rwe       <= 0;
                r_dst     <= 0;
                rwd       <= 0;
                link      <= 0;
                byte_s    <= 0;
                access_size <= 0;
              end
           end
           //Branch Instructions that I may or may not like
           6'b000110: begin
              $display("blez, rs: %h, rt: %h, offset: %h", rs, rt, offset);
              br        <= 1;
              jp        <= 0;
              sign_x    <= 0;
              alu_in_b  <= 0;
              alu_op    <= op_code;
              d_mem_we  <= 0;
              rwe       <= 0;
              r_dst     <= 0;
              rwd       <= 0;
              link      <= 0;
              byte_s    <= 0;
              access_size <= 0;
            end
           6'b000111: begin
              $display("bgtz, rs: %h, rt: %h, offset: %h", rs, rt, offset);
              br        <= 1;
              jp        <= 0;
              sign_x    <= 0;
              alu_in_b  <= 0;
              alu_op    <= op_code;
              d_mem_we  <= 0;
              rwe       <= 0;
              r_dst     <= 0;
              rwd       <= 0;
              link      <= 0;
              byte_s    <= 0;
              access_size <= 0;
            end
           //Immediate Instructions
           6'b001000: begin
              $display("addi, rs: %h, rt: %h, immediate: %h", rs, rt, im);
              br        <= 0;
              jp        <= 0;
              sign_x    <= 1;
              alu_in_b  <= 1;
              alu_op    <= op_code;
              d_mem_we  <= 0;
              rwe       <= 1;
              r_dst     <= 0;
              rwd       <= 0;
              link      <= 0;
              byte_s    <= 0;
              access_size <= 0;
            end
           6'b001001: begin
              $display("addiu, rs: %h, rt: %h, immediate: %h", rs ,rt, im);
              br        <= 0;
              jp        <= 0;
              sign_x    <= 1;
              alu_in_b  <= 1;
              alu_op    <= op_code;
              d_mem_we  <= 0;
              rwe       <= 1;
              r_dst     <= 0;
              rwd       <= 0;
              link      <= 0;
              byte_s    <= 0;
              access_size <= 0;
            end
            6'b011100: begin
              $display("mul, rs: %h, rt: %h, rd: %h", rs,rt,rd);
              br        <= 0;
              jp        <= 0;
              sign_x    <= 1;
              alu_in_b  <= 0;
              alu_op    <= op_code;
              d_mem_we  <= 0;
              rwe       <= 1;
              r_dst     <= 1;
              rwd       <= 0;
              link      <= 0;
              byte_s    <= 0;
              access_size <= 0;
            end
           6'b001010: begin
              $display("slti, rs: %h, rt: %h, immediate: %h", rs, rt, im);
              br        <= 0;
              jp        <= 0;
              sign_x    <= 1;
              alu_in_b  <= 1;
              alu_op    <= op_code;
              d_mem_we  <= 0;
              rwe       <= 1;
              r_dst     <= 0;
              rwd       <= 0;
              link      <= 0;
              byte_s    <= 0;
              access_size <= 0;
            end
           6'b001011: begin
            $display("sltiu, rs: %h, rt: %h, immediate: %h", rs, rt, im);
            br        <= 0;
            jp        <= 0;
            sign_x    <= 1;
            alu_in_b  <= 1;
            alu_op    <= op_code;
            d_mem_we  <= 0;
            rwe       <= 1;
            r_dst     <= 0;
            rwd       <= 0;
            link      <= 0;
            byte_s    <= 0;
            access_size <= 0;
          end
           6'b001101: begin
              $display("ori, rs: %h, rt: %h, immediate: %h", rs, rt, im);
              br        <= 0;
              jp        <= 0;
              sign_x    <= 0;
              alu_in_b  <= 1;
              alu_op    <= op_code;
              d_mem_we  <= 0;
              rwe       <= 1;
              r_dst     <= 0;
              rwd       <= 0;
              link      <= 0;
              byte_s    <= 0;
              access_size <= 0;
            end
           6'b001110: begin
              $display("xori, rs: %h, rt: %h, immediate: %h",rs, rt, im);
              br        <= 0;
              jp        <= 0;
              sign_x    <= 0;
              alu_in_b  <= 1;
              alu_op    <= op_code;
              d_mem_we  <= 0;
              rwe       <= 1;
              r_dst     <= 0;
              rwd       <= 0;
              link      <= 0;
              byte_s    <= 0;
              access_size <= 0;
            end

           6'b001111: begin
              $display("lui, rs: %h, rt: %h, immediate: %h",rs, rt, im);
              br        <= 0;
              jp        <= 0;
              sign_x    <= 0;
              alu_in_b  <= 1;
              alu_op    <= op_code;
              d_mem_we  <= 0;
              rwe       <= 1;
              r_dst     <= 0;
              rwd       <= 0;
              link      <= 0;
              byte_s    <= 0;
              access_size <= 0;
            end
           //memory instructions
           6'b100000: begin
              $display("lb, base: %h, rt: %h, offset: %h", base, rt, offset);
              br          <= 0;
              jp          <= 0;
              sign_x      <= 1;
              alu_in_b    <= 1;
              alu_op      <= op_code;
              d_mem_we    <= 0;
              rwe         <= 1;
              r_dst       <= 0;
              rwd         <= 1;
              access_size <= 1;
              byte_s      <= 1;
              link        <= 0;

           end
           6'b100011: begin
              $display("lw, base: %h, rt: %h, offset: %h", base, rt, offset);
              br          <= 0;
              jp          <= 0;
              sign_x      <= 1;
              alu_in_b    <= 1;
              alu_op      <= op_code;
              d_mem_we    <= 0;
              rwe         <= 1;
              r_dst       <= 0;
              rwd         <= 1;
              access_size <= 0;
              byte_s      <= 1'bx;
              link        <= 0;

            end
           6'b100100: begin
              $display("lbu, base: %h, rt: %h, offset: %h", base, rt, offset);
              br          <= 0;
              jp          <= 0;
              sign_x      <= 1;
              alu_in_b    <= 1;
              alu_op      <= op_code;
              d_mem_we    <= 0;
              rwe         <= 1;
              r_dst       <= 0;
              rwd         <= 1;
              access_size <= 1;
              byte_s      <= 0;
              link        <= 0;

            end
           6'b101000: begin
              $display("sb, base: %h, rt: %h, offset: %h", base, rt, offset);
              br          <= 0;
              jp          <= 0;
              sign_x      <= 1;
              alu_in_b    <= 1;
              alu_op      <= op_code;
              d_mem_we    <= 1;
              rwe         <= 0;
              r_dst       <= 0;
              rwd         <= 0;
              access_size <= 1;
              byte_s      <= 1'bx;
              link        <= 0;
            end
           6'b101011: begin
              $display("sw, base: %h, rt: %h, offset: %h", base, rt, offset);
              br          <= 0;
              jp          <= 0;
              sign_x      <= 1;
              alu_in_b    <= 1;
              alu_op      <= op_code;
              d_mem_we    <= 1;
              rwe         <= 0;
              r_dst       <= 0;
              rwd         <= 0;
              access_size <= 0;
              byte_s      <= 1'bx;
              link        <= 0;
            end

           //defaulting
           default: $display("INVALID");
        endcase
    end
  end
end


endmodule
