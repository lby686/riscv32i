`timescale 1ns / 1ps


`include "Parameters.v"
//两个操作数，根据sel不同选择不同的计算方式，并输出到AluOut中
module ALU(input wire [31:0] Operand1,
           input wire [31:0] Operand2,
           input wire [3:0] ALUContrl, 
           output reg [31:0] AluOut);
    always@(*) begin
        case(ALUContrl)
            `ADD:        AluOut<=Operand1 + Operand2; 
            `SUB:        AluOut<=Operand1 - Operand2; 
            `AND:        AluOut<=Operand1 & Operand2; 
            `OR:         AluOut<=Operand1 | Operand2; 
            `XOR:        AluOut<=Operand1 ^ Operand2; 
            `SLL:        AluOut<=Operand1 << Operand2[4:0];
            `SRL:        AluOut<=Operand1 >> Operand2[4:0];
            `SRA:        AluOut<=$signed(Operand1) >>> Operand2[4:0];
            `LUI:        AluOut<={ Operand2[31:12],12'b0 };
            `SLT:        AluOut<=($signed(Operand1) < $signed(Operand2)) ? 32'h00000001 : 32'h00000000;
            `SLTU:       AluOut<=($unsigned(Operand1) < $unsigned(Operand2)) ? 32'h00000001 : 32'h00000000;
            default:    AluOut <= 32'hxxxxxxxx;
        endcase
    end
endmodule
//ALUContrl类型定义于Parameters.v中//功能和接口说明
	//ALU接受两个操作数，根据AluContrl的不同，进行不同的计算操作，将计算结果输出到AluOut
	//AluContrl的类型定义在Parameters.v中
//推荐格式：
    //case()
    //    `ADD:        AluOut<=Operand1 + Operand2; 
    //   	.......
    //    default:    AluOut <= 32'hxxxxxxxx;                          
    //endcase
//实验要求  
    //实现ALU模块