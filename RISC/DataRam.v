`timescale 1ns / 1ps


module DataRam(
    input  clk,
    input  [ 3:0] wea,
    input  [31:2] addra,
    input  [31:0] dina ,
    output reg [31:0] douta
);
initial begin douta=0; end

wire addra_valid = ( addra[31:14]==18'h0 );
wire [11:0] addral = addra[13:2];

reg [31:0] ram_cell [0:4095];

initial begin    // add simulation data here
    ram_cell[0] = 32'h00000000;
    // ......
end

always @ (posedge clk)
    douta <= addra_valid ? ram_cell[addral] : 0;

always @ (posedge clk)
    if(wea[0] & addra_valid) 
        ram_cell[addral][ 7: 0] <= dina[ 7: 0];
        
always @ (posedge clk)
    if(wea[1] & addra_valid) 
        ram_cell[addral][15: 8] <= dina[15: 8];
        
always @ (posedge clk)
    if(wea[2] & addra_valid) 
        ram_cell[addral][23:16] <= dina[23:16];
        
always @ (posedge clk)
    if(wea[3] & addra_valid) 
        ram_cell[addral][31:24] <= dina[31:24];
        
endmodule

//功能说明
    //同步读写bram，a、b双口可读写，a口用于CPU访问dataRam，b口用于外接debug_module进行读写
    //写使能为4bit，支持byte write
//输入
    //clk               输入时钟
    //addra             a口读写地址
    //dina              a口写输入数据
    //wea               a口写使能
    //addrb             b口读写地址
    //dinb              b口写输入数据
    //web               b口写使能
//输出
    //douta             a口读数据
    //doutb             b口读数据
//实验要求  
    //无需修改