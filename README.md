## cod-singlecyclecpu
## 这是武汉大学计算机学院计算机组成与设计课程设计的一部分
# RISC-V 单周期实现
### Yili Gong
### 2023.05

注意事项：
1. regfile.v
参考给你的regfile.v文件，修改你的寄存器实现，在寄存器值被修改时，输出修改它的指令地址、被修改的寄存器地址和被修改的值。
这里分别是pc、wa3和wd3，替换成你的实现中的线或者值。
务必保持格式不变！

	// DO NOT CHANGE THIS display LINE!!!
	// 不要修改下面这行display语句！！！
	/**********************************************************************/
    	$display("x%d = %h", wa3, wd3);
	/**********************************************************************/

2. testbench.v
testbench文件中的打印语句可以用于调试，但是正式提交评测时会使用服务器上的tb文件，其中是没有这些打印语句的
务必保持tb文件中CPU模块的模块名和引脚名不变
xgriscv：RISC-V CPU模块；clk：时钟；rstn：reset；pc：当前正在执行的指令的pc

   // instantiation of xgriscv_sc
   xgriscv_sc xgriscv(clk, rstn, pc);

其他文件中的模块和引脚名可自定义

指令内存的存放指令的模块名也不能变

    // input instruction for simulation
    $readmemh("riscv32_sim1.dat", xgriscv.U_imem.RAM);

testbench文件中下述语句是用来让仿真在执行完后停止，需要根据每个测试程序的大小进行调整，设置为最后一条指令的地址即可

	if (pc == 32'h80000078) // set to the address of the last instruction
    begin

    	$stop;
    end
