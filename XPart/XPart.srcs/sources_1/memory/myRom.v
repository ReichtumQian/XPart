`timescale 1ns / 1ps


module myRom(
    input [11:0] address,
    output [31:0] out
);
    reg [31:0] rom [0:4095];
    integer i;


    localparam FILE_PATH = "../../../../../Software/kernel.sim";
    initial begin
        for(i = 0; i < 4096; i = i+1) begin
          rom[i] = 0;
        end
        $readmemh(FILE_PATH, rom);
    end


    assign out = rom[address];
endmodule
