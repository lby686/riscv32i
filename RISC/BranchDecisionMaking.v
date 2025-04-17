`timescale 1ns / 1ps


`include "Parameters.v"   
module BranchDecisionMaking(
    input wire [2:0] BranchTypeE,
    input wire [31:0] Operand1,Operand2,
    output reg BranchE
    );
    always @(*) begin
    case(BranchTypeE)
        `BEQ:begin 
            if(Operand1==Operand2) BranchE<=1'b1;
            else BranchE<=1'b0;
        end
        `BNE:begin
            if(Operand1!=Operand2) BranchE<=1'b1;
            else BranchE<=1'b0;
            end
        `BLT:begin
            if($signed(Operand1)<$signed(Operand2)) BranchE<=1'b1;
            else BranchE<=1'b0;
            end
        `BGE:begin
            if($signed(Operand1)>=$signed(Operand2)) BranchE<=1'b1;
            else BranchE<=1'b0;
            end
        `BLTU:begin
            if(Operand1<Operand2) BranchE<=1'b1;
            else BranchE<=1'b0;
            end
        `BGEU:begin
            if(Operand1>=Operand2) BranchE<=1'b1;
            else BranchE<=1'b0;
            end
        default: BranchE<=1'b0;
    endcase
    end
endmodule

//功能和接口说明
    //BranchDecisionMaking接受两个操作数，根据BranchTypeE的不同，进行不同的判断，当分支应该taken时，令BranchE=1'b1
    //BranchTypeE的类型定义在Parameters.v中
//推荐格式：
    //case()
    //    `BEQ: ???
    //      .......
    //    default:                            BranchE<=1'b0;  //NOBRANCH
    //endcase
//实验要求  
    //实现BranchDecisionMaking模块