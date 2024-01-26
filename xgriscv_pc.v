module pc( clk, rstn, npc, pc);
  input              clk;
  input             rstn;
  input       [31:0] npc;
  output reg  [31:0] pc;

  always @(posedge clk, posedge rstn)
    if (rstn) 
      pc <= 32'h0000_0000;
    else
      pc <= npc;     
endmodule

module npc(pc, NPCOp, Zero,immout, npc,aluout, ALUOp,rs1, pcM);
    input  [31:0] pc;
    input  [2:0]  NPCOp;     // 获得下一个PC地址的控制信号
    input  [31:0] immout;
    input [31:0] aluout;
    input [4:0] ALUOp;
    input Zero;
    input [4:0] rs1;

    output reg [31:0] npc;
    output [31:0] pcM;
   
    assign pcM = pc;
   
always@(*)begin
        begin 
            begin
            case(NPCOp)
            `NPC_PLUS4: npc = pc +4;                            
            `NPC_BRANCH:begin 
                        case(ALUOp)
                        `ALUOp_sub:if(Zero==1) npc =pc+immout; else npc = pc +4;
                        `ALUOp_bne:if(Zero==0) npc =pc+immout; else npc = pc +4;
                        `ALUOp_blt:if(aluout==1) npc =pc+immout; else npc = pc +4;
                        `ALUOp_bge:if(aluout==1) npc =pc+immout; else npc = pc +4;
                        `ALUOp_bltu:if(aluout==1) npc =pc+immout; else npc = pc +4;
                        `ALUOp_bgeu:if(aluout==1) npc =pc+immout; else npc = pc +4;
                        default: npc = pc +4;
                        endcase
                        end
            `NPC_JUMP: npc = pc+immout; 
            `NPC_JALR: npc = U_RF.rf[rs1]+immout;
            endcase
           end
        end
    end
endmodule