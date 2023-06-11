`timescale 1ns / 1ps



module CSR(
  input clk,
  input rst,
  input csr_write,  // 是否写 CSR 寄存器
  input id_ecall,      // 是否是 ecall 指令（如果是则需要写 PC）
  input wb_ecall,
  input[11:0] csr_read_addr,  // 读取的目标 CSR 寄存器（因为读写不同步）
  input[11:0] csr_write_addr, // 写入的目标 CSR 寄存器
  input[63:0] data_in,
  input[63:0] wb_pc,   // mepc 可能要保存 pc 的值
  input[1:0] pc_src,   // 用于判断是否为 ecall 和 mret
  
  output reg[63:0] data_out
);

//`define NUM_CSR 16
//integer i;
//reg[31:0] register[0:`NUM_CSR];

//`define mstatus register[0]  // csr = 0x300
//`define mtvec register[5]    // csr = 0x305
//`define mepc register[]

reg[63:0] mstatus;
reg[63:0] mtvec;
reg[63:0] mepc;
reg[63:0] mcause;



always @(negedge clk or posedge rst) begin
   if(rst) begin
      mstatus <= 0;
      mtvec <= 0;
      mepc <= 0;
      mcause <= 0;
    end
    else begin
      if(csr_write)begin
        case(csr_write_addr) 
          12'h300: mstatus <= data_in;
          12'h305: mtvec <= data_in;
          12'h341: mepc <= data_in;
          12'h342: mcause <= data_in;
        endcase
      end
      if(wb_ecall) begin // 如果 ecall 则保存 pc
        mepc <= wb_pc;
      end
    
    if(id_ecall)begin
      data_out <= mtvec;
    end
    else if(pc_src == 3) begin // mret
      data_out <= mepc;
    end
    else begin
      case(csr_read_addr)
        12'h300: data_out <= mstatus;
        12'h305: data_out <= mtvec;
        12'h341: data_out <= mepc ;
        12'h342: data_out <= mcause ;
        default: data_out <= 0;
      endcase
    end
end
end




endmodule

