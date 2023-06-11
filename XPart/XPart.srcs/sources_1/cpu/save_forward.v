`timescale 1ns / 1ps


module save_forward(
  input clk,
  input[6:0] mem_op_code,
  input[4:0] mem_rs2,
  input[63:0] mem_data2,
  
  input wb_reg_write,
  input[4:0] wb_rd,
  input[63:0] wb_alu_result,
//  output reg save_forward
  output reg[63:0] data_out
);

//reg now_reg_write;
//reg[4:0] now_rd;
//reg[31:0] now_alu_result;


reg before_reg_write1;
reg[4:0] before_rd1;
reg[63:0] before_alu_result1;

reg before_reg_write2;
reg[4:0] before_rd2;
reg[63:0] before_alu_result2;


always@(*) begin
  // save_forward 
  // 0 表示未发生 save hazard
  // rs1 不需要前递（因为 ALU 的前递已经处理掉了）
  // 1 表示 rs2 需要前递
//  if(mem_op_code == 7'b0100011 && wb_reg_write == 1) begin
//    if(mem_rs2 == wb_rd) save_forward <= 1;
//    else save_forward <= 0;
//  end
//  else save_forward <= 0;
  
  // 选择 data_out
  if(mem_op_code == 7'b0100011 && wb_reg_write == 1)begin
    if(mem_rs2 == wb_rd) data_out = wb_alu_result;
    else data_out = mem_data2;
  end 
  else if(mem_op_code == 7'b0100011 && before_reg_write1 == 1)begin
    if(mem_rs2 == before_rd1) data_out = before_alu_result1;
    else data_out = mem_data2;
  end
  else if(mem_op_code == 7'b0100011 && before_reg_write2 == 1)begin
    if(mem_rs2 == before_rd2) data_out = before_alu_result2;
    else data_out = mem_data2;
  end
  else data_out = mem_data2;

end

always @(posedge clk) begin
  before_reg_write2 = before_reg_write1;
  before_rd2 = before_rd1;
  before_alu_result2 = before_alu_result1;
  
  before_reg_write1 = wb_reg_write;
  before_rd1 = wb_rd;
  before_alu_result1 = wb_alu_result;

end


endmodule
