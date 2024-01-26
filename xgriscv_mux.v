`include "xgriscv_defines.v"

module alu_mux(
    input [31:0] immout,
    input [31:0] RD2,
    input ALUSrc,
    output [31:0] result
    );
    assign result = (ALUSrc) ? immout : RD2;
endmodule


module regfile_mux(
    input[1:0] WDSel,
    input[31:0] dout,
    input[31:0] aluout,
    input[31:0] PC_out,
    output reg [31:0] WD
    );
always @(*)begin
	case(WDSel)
		`WDSel_FromALU: WD<=aluout;
		`WDSel_FromMEM: WD<=dout;
		`WDSel_FromPC:  WD<=PC_out+4;
	endcase
end
endmodule