`include "xgriscv_defines.v"
module xgriscv_sc(clk, reset, pcM);
  input             clk, reset;
  output [31:0]     pcM;
   
  wire [31:0] instr;
  wire [31:0] pc;
  wire        memwrite;
  wire [31:0] addr,writedata,readdata;

    xgriscv_top U_top (
    .clk(clk),
    .reset(reset),
    .instr(instr),
    .readdata(readdata),
    .memwrite(memwrite),
    .pc(pc),
    .addr(addr),
    .writedata(writedata),
    .pcM(pcM)
  );

  imem U_imem(pc, instr);

  dmem U_dmem(clk, memwrite, addr, writedata, pc, readdata);
  
  
endmodule
