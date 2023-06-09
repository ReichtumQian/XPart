
`timescale 1ns / 1ps

module ID_EX_Reg(
  input clk,
  input rst,


  // input: data
  input[63:0] data1_in,
  input[63:0] data2_in,

  // input: inst & pc
  input[63:0] pc_in,
  input[31:0] inst_in,
  input predict_in, // predict whether to take branch

  // input: control signals
  input[1:0] pc_src_in,
  input reg_write_in,
  input[1:0] alu_src_b_in,
  input branch_in,
  input[2:0] b_type_in,
  input[3:0] alu_op_in,
  input[2:0] mem_to_reg_in,
  input mem_write_in,

  // input: imm
  input[63:0] imm_in,
  
  // input: csr
  input csr_write_in,
  input csr_ecall_in,
  input[63:0] csr_data_out_in, 
  
  input stall,
  input is_load,
  input stop,
  
  
  

  // output: data
  output[63:0] data1_out,
  output[63:0] data2_out,

  // output: inst & pc
  output[31:0] inst_out,
  output[63:0] pc_out,
  output predict_out,

  // output: control signals
  output[1:0] pc_src_out,
  output reg_write_out,
  output[1:0] alu_src_b_out,
  output branch_out,
  output[2:0] b_type_out,
  output[3:0] alu_op_out,
  output mem_write_out,
  output[2:0] mem_to_reg_out,
  
  output csr_write_out,
  output csr_ecall_out,
  output[63:0] csr_data_out_out, // ��ȡ�� csr �Ĵ���

  // output: imm
  output[63:0] imm_out
);

reg[63:0] data1;
reg[63:0] data2;
reg[63:0] pc;
reg[63:0] inst;
reg[63:0] imm;
reg predict;

assign data1_out = data1;
assign data2_out = data2;
assign pc_out = pc;
assign inst_out = inst;
assign imm_out = imm;
assign predict_out = predict;

Control_Signal_Reg control_signal_reg(
  .clk(clk),
  .rst(rst),
  .stall(stall),
  .is_load(is_load),
  .stop(stop),

  .pc_src_in(pc_src_in),
  .reg_write_in(reg_write_in),
  .alu_src_b_in(alu_src_b_in),
  .branch_in(branch_in),
  .b_type_in(b_type_in),
  .alu_op_in(alu_op_in),
  .mem_to_reg_in(mem_to_reg_in),
  .mem_write_in(mem_write_in),
  .csr_write_in(csr_write_in),
  .csr_ecall_in(csr_ecall_in),
  .csr_data_out_in(csr_data_out_in),

  .pc_src_out(pc_src_out),
  .reg_write_out(reg_write_out),
  .alu_src_b_out(alu_src_b_out),
  .branch_out(branch_out),
  .b_type_out(b_type_out),
  .alu_op_out(alu_op_out),
  .mem_write_out(mem_write_out),
  .mem_to_reg_out(mem_to_reg_out),
  .csr_write_out(csr_write_out),
  .csr_ecall_out(csr_ecall_out),
  .csr_data_out_out(csr_data_out_out)
);



always @(posedge clk or posedge rst) begin
  if(rst) begin
    data1 <= 0;
    data2 <= 0;
    pc <= 0;
    inst <= 0;
    imm <= 0;
    predict <= 0;
  end
  else if(stop) begin
  end
  else begin
    data1 <= data1_in;
    data2 <= data2_in;
    pc <= pc_in;
    inst <= inst_in;
    imm <= imm_in;
    predict <= predict_in;
  end
end







endmodule