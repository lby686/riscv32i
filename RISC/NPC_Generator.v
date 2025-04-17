`timescale 1ns / 1ps


module NPC_Generator(
    input wire [31:0] PCF,JalrTarget, BranchTarget, JalTarget,
    input wire BranchE,JalD,JalrE,
    output reg [31:0] PC_In
    );
    //EX阶段前于ID阶段，ID阶段的JaLD应该放在if判断的后面判断
    always@(*)begin
        if(BranchE)begin
            PC_In = BranchTarget;
        end
        else if(JalrE)begin
            PC_In = JalrTarget;
        end
        else if(JalD)begin
            PC_In = JalTarget;
        end
        else begin
            PC_In = PCF + 4;
        end
    end
endmodule

//功能说明
    //NPC_Generator是用来生成Next PC值得模块，根据不同的跳转信号选择不同的新PC值
//输入
    //PCF              旧的PC值
    //JalrTarget       jalr指令的对应的跳转目标
    //BranchTarget     branch指令的对应的跳转目标
    //JalTarget        jal指令的对应的跳转目标
    //BranchE==1       Ex阶段的Branch指令确定跳转
    //JalD==1          ID阶段的Jal指令确定跳转
    //JalrE==1         Ex阶段的Jalr指令确定跳转
//输出
    //PC_In            NPC的值
//实验要求  
    //实现NPC_Generator模块  
