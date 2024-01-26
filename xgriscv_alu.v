`include "xgriscv_defines.v"

module alu(
    input signed[31:0]A,B,
    input[4:0]ALUOp,
    input[31:0]rom_addr,
    output reg signed[31:0]C,
    output reg[7:0]Zero
    );
    //根据宏定义判断alu的功能
    always@(*) begin
        case(ALUOp)
            `ALUOp_lui:C=B+0;
            `ALUOp_auipc:C=B+rom_addr;
            `ALUOp_add:C=A+B;                                //加法
            `ALUOp_sub:C=A-B;                                //减法
            `ALUOp_sll:C=A<<B[4:0];                          //左移
            `ALUOp_slt:C=(A<B)?1:0;                          //判断有符号数大小
            `ALUOp_sltu:C=($unsigned(A)<$unsigned(B))?1:0;   //判断无符号数大小
            `ALUOp_xor:C=A^B;                                //异或
            `ALUOp_srl:C=A>>B[4:0];                          //逻辑右移
            `ALUOp_sra:C=A>>>B[4:0];                         //算术右移
            `ALUOp_or:C=A|B;                                 //或
            `ALUOp_and:C=A&B;                                //与
            `ALUOp_bne:C=A-B;
            `ALUOp_blt:C=(A<B)?1:0;
            `ALUOp_bge:C=(A>=B)?1:0;
            `ALUOp_bltu:C=($unsigned(A)<$unsigned(B))?1:0;
            `ALUOp_bgeu:C=($unsigned(A)>=$unsigned(B))?1:0;
            `ALUOp_slti:C=(A<B)?1:0;
            `ALUOp_sltiu:C=($unsigned(A)<$unsigned(B))?1:0;
            default:C=32'hFFFFFFFF;
        endcase
    //根据Zero信号判断两个值是否相等或大小关系
    Zero=(C==0)?1:0;
    end
endmodule