`timescale 1ns / 1ps


module HarzardUnit(
    input wire CpuRst, ICacheMiss, DCacheMiss, 
    input wire BranchE, JalrE, JalD, 
    input wire [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,
    input wire [1:0] RegReadE,
    input wire MemToRegE,
    input wire [2:0] RegWriteM, RegWriteW,
    output reg StallF, FlushF, StallD, FlushD, StallE, FlushE, StallM, FlushM, StallW, FlushW,
    output reg [1:0] Forward1E, Forward2E
    );
    always@(*)begin
        // 默认值：无冒险，无相关
        {StallF, FlushF, StallD, FlushD, StallE, FlushE, StallM, FlushM, StallW, FlushW} = 10'b0;
        Forward1E = 2'b00;
        Forward2E = 2'b00;
        
        //CPU全局复位清零
        if(CpuRst)begin
            {FlushF, FlushD, FlushE, FlushM, FlushW} = 5'b11111;
            {StallF, StallD, StallE, StallM, StallW} = 5'b00000;
        end
        
        //*****控制冒险*****
        if(BranchE || JalrE)begin
        //EX阶段遇到跳转指令，则清空ID和EX段寄存器
            FlushD = 1'b1;
            FlushE = 1'b1;
        end

        //ID阶段遇到跳转指令，则清空ID段寄存器
        if(JalD)begin
            FlushD = 1'b1;
        end

        //*****数据冒险*****
        // 情况 1：MEM 阶段的 RdM 对 EX 阶段的 Rs1E 和 Rs2E 的前递（将ALU计算出来的数据写回寄存器，但下一条指令用到了）
        if(RegWriteM != 3'b0)begin
            if(RdM == Rs1E && RegReadE[1]) Forward1E = 2'b10;
            if(RdM == Rs2E && RegReadE[0]) Forward2E = 2'b10;
        end

        // 情况 2：WB 阶段的 RdW 对 EX 阶段的 Rs1E 和 Rs2E 的前递（数据存储器内取出的数据写回寄存器，且下下条指令用到了）
        if(RegWriteW != 3'b0)begin
            if(~(RdM == Rs1E && RegReadE[1]) && RdW == Rs1E && RegReadE[1]) Forward1E = 2'b01;  //考虑当前指令与上条和上上条同时相关，即情况1和情况2同时存在，则优先情况1
            if(~(RdM == Rs2E && RegReadE[0]) && RdW == Rs2E && RegReadE[0]) Forward2E = 2'b01;  //因为情况1是上条指令，当前指令使用的值应当是上条指令的值，而不是上上条指令的值
        end

        // 情况 3：数据冒险 - Load-Use 冒险（EX 阶段的 MemToRegE 导致的冒险，需要通过stall来解决）
        if(~CpuRst && MemToRegE && (Rs1D == RdE || Rs2D == RdE))begin
            StallF = 1'b1;
            StallD = 1'b1;
            FlushE = 1'b1;
        end

        //Stall and Flush signals generate

        //Forward Register Source 1

        //Forward Register Source 2
    end
endmodule

//功能说明
    //HarzardUnit用来处理流水线冲突，通过插入气泡，forward以及冲刷流水段解决数据相关和控制相关，组合逻辑电路
    //可以最后实现。前期测试CPU正确性时，可以在每两条指令间插入四条空指令，然后直接把本模块输出定为，不forward，不stall，不flush 
//输入
    //CpuRst                                    外部信号，用来初始化CPU，当CpuRst==1时CPU全局复位清零（所有段寄存器flush），Cpu_Rst==0时cpu开始执行指令
    //ICacheMiss, DCacheMiss                    为后续实验预留信号，暂时可以无视，用来处理cache miss
    //BranchE, JalrE, JalD                      用来处理控制相关
    //Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW     用来处理数据相关，分别表示源寄存器1号码，源寄存器2号码，目标寄存器号码
    //RegReadE RegReadD[1]==1                   表示A1对应的寄存器值被使用到了，RegReadD[0]==1表示A2对应的寄存器值被使用到了，用于forward的处理
    //RegWriteM, RegWriteW                      用来处理数据相关，RegWrite!=3'b0说明对目标寄存器有写入操作
    //MemToRegE                                 表示Ex段当前指令 从Data Memory中加载数据到寄存器中
//输出
    //StallF, FlushF, StallD, FlushD, StallE, FlushE, StallM, FlushM, StallW, FlushW    控制五个段寄存器进行stall（维持状态不变）和flush（清零）
    //Forward1E, Forward2E                                                              控制forward
//实验要求  
    //实现HarzardUnit模块   
