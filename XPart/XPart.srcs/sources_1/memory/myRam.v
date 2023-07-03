`timescale 1ns / 1ps


module myRam(
    input clk,
    input we,
    input [63:0] write_data,
    input [11:0] address,
    output [63:0] read_data
    );
    reg [63:0] ram [0:4095];
    integer i;

    always @(posedge clk) begin
        if (we == 1) ram[address] <= write_data;
    end

    assign read_data = ram[address];


//    localparam FILE_PATH = "";
    initial begin
      for(i = 0; i < 4096; i = i+1) begin
        ram[i] = 0;
      end
//        $readmemh(FILE_PATH, ram);
    end
endmodule
