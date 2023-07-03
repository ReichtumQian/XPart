`timescale 1ns / 1ps


module myRom(
    input [11:0] address,
    output [31:0] out
);
    reg [31:0] rom [0:4095];


    localparam FILE_PATH = "../../../../../Software/kernel.sim";
    initial begin
        $readmemh(FILE_PATH, rom);
    end


    assign out = rom[address];
endmodule
