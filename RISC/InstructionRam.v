`timescale 1ns / 1ps

module InstructionRam(
    input  clk,
    input  [31:2] addra,
    output reg [31:0] douta
);
initial begin douta=0; /*doutb=0*/; end

wire addra_valid = ( addra[31:14]==18'h0 );
wire [11:0] addral = addra[13:2];

reg [31:0] ram_cell [0:4095];

initial begin    // you can add simulation instructions here
    ram_cell[0] = 32'h00000000;
        // ......
end

always @ (posedge clk)
    douta <= addra_valid ? ram_cell[addral] : 0;
    

endmodule

//功能说明
    //同步读写bram，a口只读，用于取指，b口可读写，用于外接debug_module进行读写
    //写使能为1bit，不支持byte write
//输入
    //clk               输入时钟
    //addra             a口读地址
    //addrb             b口读写地址
    //dinb              b口写输入数据
    //web               b口写使能
//输出
    //douta             a口读数据
    //doutb             b口读数据
//实验要求  
    //无需修改