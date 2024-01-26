`include "xgriscv_defines.v"

module xgriscv_top(
    input      clk,           
    input      reset,         
    input [31:0]  instr,    
    input [31:0]  readdata,     
   
    output    memwrite,          
    output [31:0] pc,     
    output [31:0] addr,   
    output [31:0] writedata,
    output [31:0] pcM

);

 //Decode period
   wire [6:0]Op;  
   assign Op = instr[6:0];
   wire [6:0]Funct7;
   assign Funct7 = instr[31:25];
   wire [2:0]Funct3;
   assign Funct3 = instr[14:12];
   wire [4:0]rs1;
   assign rs1 = instr[19:15];
   wire [4:0]rs2 ;
   assign rs2= instr[24:20];
   wire [4:0]rd;
   assign rd = instr[11:7];
   wire [11:0]iimm;      
   assign iimm = instr[31:20]; 
   wire [11:0]simm;
   assign simm = {instr[31:25],instr[11:7]};
   wire [4:0] iimm_shamt;
   assign iimm_shamt = instr[24:20]; 
   wire [19:0] jimm;
   assign jimm = {instr[31],instr[19:12],instr[20],instr[30:21]};
   wire [11:0] bimm;
   assign bimm = {instr[31],instr[7],instr[30:25],instr[11:8]};
   wire [19:0] uimm;
   assign uimm = instr[31:12]; 


    wire Zero; 
    wire RegWrite;
    wire MemWrite;
    wire[5:0]EXTOp;
    wire[4:0] ALUOp;
    wire ALUSrc;
    wire [2:0] DMType;
    wire [1:0]WDSel;
    wire [2:0]NPCOp;
   decode U_DECODE(
    .Op(Op),
    .Funct3(Funct3),
    .Funct7(Funct7),
    .Zero(Zero),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .EXTOp(EXTOp),
    .ALUOp(ALUOp),
    .NPCOp(NPCOp),
    .ALUSrc(ALUSrc),
    .DMType(DMType),
    .WDSel(WDSel)
    );
    assign memwrite = MemWrite;

wire [31:0]immout;
wire [31:0] aluout; 
wire [31:0] NPC;
pc U_PC(.clk(clk), .rstn(reset), .npc(NPC), .pc(pc) );
npc U_NPC(.pc(pc), .NPCOp(NPCOp), .Zero(Zero), .immout(immout), .npc(NPC), .rs1(rs1),.ALUOp(ALUOp), .aluout(aluout), .pcM(pcM));


   ext U_EXT(
    .iimm_shamt(iimm_shamt),
    .iimm(iimm),
    .simm(simm),
    .bimm(bimm),
    .uimm(uimm),
    .jimm(jimm),
    .EXTOp(EXTOp),
    .immout(immout)
   ); 

    wire[31:0]RD1;
    wire[31:0]RD2;
    wire[31:0] WD;
   //RF的例化
    regfile U_RF(
    .clk(clk),
    .we3(RegWrite),
    .ra1(rs1),
    .ra2(rs2),
    .wa3(rd),
    .wd3(WD),
    .rd1(RD1),
    .rd2(RD2)
    );

    wire signed [31:0]A;
    wire signed [31:0]B;

    assign A=RD1;
    alu_mux U_alu_mux(
            .immout(immout),
            .RD2(RD2),
            .ALUSrc(ALUSrc),
            .result(B)
    );
 //alu例化
   alu U_alu(
        .A(A), 
        .B(B), 
        .rom_addr(pc),
        .ALUOp(ALUOp), 
        .C(aluout), 
        .Zero(Zero)
    );

  assign addr=aluout;
  assign writedata=RD2;
  assign memwrite = MemWrite;

  regfile_mux U_RF_mux(
    .WDSel(WDSel),
    .dout(readdata),
    .PC_out(pc),
    .aluout(aluout),
    .WD(WD)
);
endmodule