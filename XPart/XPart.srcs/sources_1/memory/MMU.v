
`timescale 1ns / 1ps

module MMU(
  input rst,
  input clk,
  input[63:0] va,
  input[63:0] satp,
  output stop,
  output [63:0] value 
);

reg[63:0] satp_before;
reg satp_change; // is 1 if satp_before != satp

reg[1:0] mmu_state;

parameter MMU_STATE_ONE = 2'b00,
          MMU_STATE_TWO = 2'b01,
          MMU_STATE_THREE = 2'b10; 
          MMU_STATE_FOUR = 2'b11; 

assign stop = !(satp == 0) && !(mmu_state == MMU_STATE_FOUR) || satp_change;

always @(*) begin
  if(satp == 0) mmu_state = MMU_STATE_ONE;
  satp_change = (satp_before != satp);
end

always @(negedge clk) begin
  satp_before <= satp;
end

always @(posedge clk or posedge rst) begin
  if(satp != 0) begin
    case(mmu_state)
    MMU_STATE_ONE: mmu_state = MMU_STATE_TWO;
    MMU_STATE_TWO: mmu_state = MMU_STATE_THREE;
    MMU_STATE_THREE: mmu_state = MMU_STATE_FOUR;
    MMU_STATE_FOUR: mmu_state = MMU_STATE_ONE;
    endcase
  end
end


endmodule
