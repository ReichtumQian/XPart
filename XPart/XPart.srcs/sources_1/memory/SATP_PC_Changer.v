
// 在 satp 修改时修改 pc

module SATP_PC_Changer(
  input rst,
  input clk,
  input satp_change,
  input[63:0] satp,
  input[63:0] pc_in,
  input[63:0] mem_value,
  output[63:0] mem_addr, // read mem
  output reg stop,
  output reg[63:0] pc_out
);

always @(posedge clk or posedge rst) begin
  if(rst) begin
    stop <= 0;
    pc_out <= 0;
  end
  else if(satp_change) begin  // satp is changed
    stop <= 1;
  end
  else begin // satp is not changed
    stop <= 0;
  end

end


endmodule