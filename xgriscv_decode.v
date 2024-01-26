`include "xgriscv_defines.v"

module decode(
    input [6:0] Op,  //opcode
    input [6:0] Funct7,  //funct7 
    input [2:0] Funct3,    // funct3 
    input Zero,
    output RegWrite, // control signal for register write
    output MemWrite, // control signal for memory write
    output	[5:0]EXTOp,    // control signal to signed extension
    output [4:0] ALUOp,    // ALU opertion
    output [2:0] NPCOp,    // next pc operation
    output ALUSrc,   // ALU source for b
    output [2:0] DMType, //dm r/w type
    output [1:0] WDSel    // (register) write data selection  (MemtoReg)
    );
    
 //R-type judgement  add sub sll slt sltu xor srl or and
wire rtype= ~Op[6]&Op[5]&Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0110011
wire i_add=rtype&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]&~Funct3[0]; // add 0000000 000
wire i_sub=rtype&~Funct7[6]&Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]&~Funct3[0]; // sub 0100000 000
wire i_sll=rtype&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]&Funct3[0]; // sll 0000000 001
wire i_slt=rtype&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&Funct3[1]&~Funct3[0]; // slt 0000000 010
wire i_sltu=rtype&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&Funct3[1]&Funct3[0]; // sltu 0000000 011
wire i_xor=rtype&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&Funct3[2]&~Funct3[1]&~Funct3[0]; // xor 0000000 100
wire i_srl=rtype&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&Funct3[2]&~Funct3[1]&Funct3[0]; // srl 0000000 101
wire i_sra=rtype&~Funct7[6]&Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&Funct3[2]&~Funct3[1]&Funct3[0]; // srA 0100000 101
wire i_or=rtype&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&Funct3[2]&Funct3[1]&~Funct3[0]; // srA 0000000 110
wire i_and=rtype&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&Funct3[2]&Funct3[1]&Funct3[0]; // srA 0000000 111

//I-type judgement  lb,lh,lw
wire itype_l  = ~Op[6]&~Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0000011
wire i_lb=itype_l&~Funct3[2]& ~Funct3[1]& ~Funct3[0]; //lb 000
wire i_lh=itype_l&~Funct3[2]& ~Funct3[1]& Funct3[0];  //lh 001
wire i_lw=itype_l&~Funct3[2]& Funct3[1]& ~Funct3[0];  //lw 010
wire i_lbu = itype_l&Funct3[2]& ~Funct3[1]& ~Funct3[0];//lbu 100
wire i_lhu = itype_l&Funct3[2]& ~Funct3[1]& Funct3[0];//lhu 101

//addi judgement
wire itype_r  = ~Op[6]&~Op[5]&Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0010011
wire i_addi  =  itype_r& ~Funct3[2]& ~Funct3[1]& ~Funct3[0]; // addi 000 func3
wire i_slti  =  itype_r& ~Funct3[2]& Funct3[1]& ~Funct3[0]; //slti 010
wire i_sltiu  =  itype_r& ~Funct3[2]& Funct3[1]& Funct3[0]; //sltiu 011
wire i_xori  =  itype_r& Funct3[2]& ~Funct3[1]& ~Funct3[0]; //xori 100
wire i_ori  =  itype_r& Funct3[2]& Funct3[1]& ~Funct3[0];   //ori 110
wire i_andi  =  itype_r& Funct3[2]& Funct3[1]& Funct3[0];   //andi 111
wire i_slli = itype_r& ~Funct3[2]& ~Funct3[1]& Funct3[0] & ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0];  //slli 001 0000000 
wire i_srli = itype_r& Funct3[2]& ~Funct3[1]& Funct3[0] & ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0];  //srli 101 0000000
wire i_srai = itype_r& Funct3[2]& ~Funct3[1]& Funct3[0] & ~Funct7[6]&Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0];  //srai 101 0100000

//S-format judgement   sw,sb,sh
wire stype=~Op[6]&Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0];//0100011
wire i_sw=~Funct3[2]&Funct3[1]&~Funct3[0];//010
wire i_sb=stype& ~Funct3[2]& ~Funct3[1]&~Funct3[0];
wire i_sh=stype&& ~Funct3[2]&~Funct3[1]&Funct3[0];

//SB-format judgement  beq,bne,blt,bge
wire sbtype = Op[6]&Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //1100011
assign i_beq = sbtype&~Funct3[2]& ~Funct3[1]& ~Funct3[0]; //beq 000
assign i_bne = sbtype&~Funct3[2]& ~Funct3[1]& Funct3[0];  //bne 001
assign i_blt = sbtype&Funct3[2]& ~Funct3[1]& ~Funct3[0];  //blt 100
assign i_bge = sbtype&Funct3[2]& ~Funct3[1]& Funct3[0];   //bge 101
assign i_bltu = sbtype&Funct3[2]& Funct3[1]& ~Funct3[0]; //bltu 110
assign i_bgeu = sbtype&Funct3[2]& Funct3[1]& Funct3[0]; //bgeu 111

//jal
assign i_jal = Op[6]&Op[5]&~Op[4]&Op[3]&Op[2]&Op[1]&Op[0];  //1101111

//jalr
assign i_jalr = Op[6]&Op[5]&~Op[4]&~Op[3]&Op[2]&Op[1]&Op[0]; //1100111

//lui
assign i_lui = ~Op[6]&Op[5]&Op[4]&~Op[3]&Op[2]&Op[1]&Op[0];//0110111 

//auipc
assign i_auipc = ~Op[6]&~Op[5]&Op[4]&~Op[3]&Op[2]&Op[1]&Op[0];//0010111

//registerWrite, memwrite,alusrc,MemeryToregister信号生成
assign RegWrite   = rtype | itype_r|itype_l | i_jal | i_jalr | i_auipc | i_lui; // register write
assign MemWrite   = stype;              // memory write
assign ALUSrc     = itype_r | stype | itype_l | i_jalr | i_auipc | i_lui; // ALU B is from instruction immediate
//mem2reg=wdsel ,WDSel_FromALU 2'b00  WDSel_FromMEM 2'b01
assign WDSel[0] = itype_l;   
assign WDSel[1] = i_jal | i_jalr;

//rtype和itype部分融合
wire add = i_add | i_addi;
wire slt = i_slt | i_slti;
wire sltu = i_sltu | i_sltiu;
wire _xor = i_xor | i_xori;
wire _or = i_or | i_ori;
wire _and = i_and | i_andi;
wire sll = i_sll | i_slli;
wire srl = i_srl | i_srli;
wire sra = i_sra | i_srai;

//ALUOp信号生成
assign ALUOp[0]= add |stype| itype_l | sll | sltu | sra | _or | i_lui | i_bne | i_bge | i_bgeu;
assign ALUOp[1]= add |stype| itype_l | sll | slt | sltu | _and | i_blt | i_bge | i_auipc;
assign ALUOp[2]= i_sub | sll | _xor | _or | _and | i_beq | i_bne | i_blt | i_bge;
assign ALUOp[3]= sll | i_slt | i_sltu | _xor | _or | _and | i_bltu | i_bgeu;
assign ALUOp[4]= srl | sra | i_slti | i_sltiu;

//符号扩展操作信号生成
assign EXTOp[0] =  i_jal; 
assign EXTOp[1] =  i_lui | i_auipc;
assign EXTOp[2] =  sbtype; 
assign EXTOp[3] =  stype;
assign EXTOp[4] =  (itype_l | itype_r | i_jalr) & (~EXTOp[5]);
assign EXTOp[5] =  sll | sra | srl; 

//dm行为操作信号生成
assign DMType[2]=i_lbu;
assign DMType[1]=i_lb | i_sb | i_lhu;
assign DMType[0]=i_lh | i_sh | i_lb | i_sb;

assign NPCOp[2] = i_jalr;
assign NPCOp[1] = i_jal;
assign NPCOp[0] = sbtype;

endmodule
