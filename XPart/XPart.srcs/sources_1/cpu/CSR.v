`timescale 1ns / 1ps



module CSR(
  input clk,
  input rst,
  input csr_write,  // �Ƿ�д CSR �Ĵ���
  input id_ecall,      // �Ƿ��� ecall ָ����������Ҫд PC��
  input wb_ecall,
  input[11:0] csr_read_addr,  // ��ȡ��Ŀ�� CSR �Ĵ�������Ϊ��д��ͬ����
  input[11:0] csr_write_addr, // д���Ŀ�� CSR �Ĵ���
  input[63:0] data_in,
  input[63:0] wb_pc,   // mepc ����Ҫ���� pc ��ֵ
  input[1:0] pc_src,   // �����ж��Ƿ�Ϊ ecall �� mret
  
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
      if(wb_ecall) begin // ��� ecall �򱣴� pc
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

