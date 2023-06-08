`timescale 1ns / 1ps


module BHT(
  input clk,
  input rst,
  input[31:0] read_pc,
  output read_predict,
  input[31:0] write_pc,  // pc to write
  input write_predict ,  // 1: taken, 0: not taken
  input write
);

integer i;
reg[25:0] predict_table[0:255]; // 24 bits for tag, 2 bits for prediction, [0:255] is the index (in total 2^8)


wire[23:0] read_tag;
wire[7:0] read_index;
wire[23:0] write_tag;
wire[7:0] write_index;

assign read_tag = read_pc[31:8];
assign read_index = read_pc[7:0];
assign write_tag = write_pc[31:8];
assign write_index = write_pc[7:0];

assign read_predict = predict_table[read_index][25:2] == read_tag ? predict_table[read_index][1] : 0;
wire[1:0] target = predict_table[write_index][1:0];

always @(negedge clk) begin
  if (rst) begin
    for (i = 0; i <= 255; i = i + 1) begin
      predict_table[i] <= 0;
    end
  end else begin
    if (write == 1) begin // need to write predict table
      predict_table[write_index][25:2] <= write_tag;
      if(write_predict == 1) begin
        case(target)
          2'b00: predict_table[write_index][1:0] <= 2'b01;
          2'b01: predict_table[write_index][1:0] <= 2'b11;
          2'b10: predict_table[write_index][1:0] <= 2'b11;
          2'b11: predict_table[write_index][1:0] <= 2'b11;
        endcase
      end 
      else begin
        case(target)
          2'b00: predict_table[write_index][1:0] <= 2'b00;
          2'b01: predict_table[write_index][1:0] <= 2'b00;
          2'b10: predict_table[write_index][1:0] <= 2'b00;
          2'b11: predict_table[write_index][1:0] <= 2'b10;
        endcase
      end
    end
  end
end



endmodule
