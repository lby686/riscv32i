`timescale 1ns / 1ps


`include "Parameters.v" 
`define signal {{JalD}, {JalrD}, {RegWriteD}, {MemToRegD}, {MemWriteD}, {LoadNpcD}, {RegReadD}, {BranchTypeD}, {AluContrlD}, {AluSrc2D}, {AluSrc1D}, {ImmType}}
module ControlUnit(
    input wire [6:0] Op,
    input wire [2:0] Fn3,
    input wire [6:0] Fn7,
    output reg JalD,
    output reg JalrD,
    output reg [2:0] RegWriteD,
    output reg MemToRegD,
    output reg [3:0] MemWriteD,
    output reg LoadNpcD,
    output reg [1:0] RegReadD,
    output reg [2:0] BranchTypeD,
    output reg [3:0] AluContrlD,
    output reg [1:0] AluSrc2D,
    output reg AluSrc1D,
    output reg [2:0] ImmType        
    );
    always@(*)begin
        case (Op)
            //{JalD}, {JalrD}, {RegWriteD}, {MemToRegD}, {MemWriteD}, {LoadNpcD}, {RegReadD}, {BranchTypeD}, {AluContrlD}, {AluSrc2D}, {AluSrc1D}, {ImmType}
            7'b0110111: begin
            //U型指令 LUI: 将立即数 imm[31:12] 加载到寄存器 rd 的高 20 位，其余位填 0。
                `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b00},{`NOBRANCH},{`LUI},{2'b10},{1'b0},{`UTYPE}};
            end

            7'b0010111: begin
            //U型指令 AUIPC: 将立即数 imm[31:12] 加载到寄存器 rd 的高 20 位，并加上当前 PC 值。
                `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b00},{`NOBRANCH},{`ADD},{2'b10},{1'b1},{`UTYPE}};
            end

            7'b1101111: begin
            //J型指令 JAL: 无条件跳转到 PC + imm[20:1]，并将跳转后的下一条指令地址存储到 rd。
                `signal = {{1'b1},{1'b0},{`LW},{1'b0},{4'b0000},{1'b1},{2'b00},{`NOBRANCH},{4'bxxxx},{2'bxx},{1'bx},{`JTYPE}};
            end

            7'b1100111: begin
            //I型指令 JALR: 无条件跳转到寄存器 rs1 + imm[11:0]，并将跳转后的下一条指令地址存储到 rd。
                `signal = {{1'b0},{1'b1},{`LW},{1'b0},{4'b0000},{1'b1},{2'b00},{`NOBRANCH},{`ADD},{2'b10},{1'b0},{`ITYPE}};
            end

            7'b1100011: begin
            //B型指令
                case(Fn3)
                    3'b000: begin
                    //BEQ: 如果 rs1 == rs2，则跳转到 PC + imm[12:1]。
                        `signal = {{1'b0},{1'b0},{`NOREGWRITE},{1'b0},{4'b0000},{1'b0},{2'b11},{`BEQ},{4'bxxxx},{2'b00},{1'b0},{`BTYPE}};
                    end
                    3'b001: begin
                    //BNE: 如果 rs1 != rs2，则跳转到 PC + imm[12:1]。
                        `signal = {{1'b0},{1'b0},{`NOREGWRITE},{1'b0},{4'b0000},{1'b0},{2'b11},{`BNE},{4'bxxxx},{2'b00},{1'b0},{`BTYPE}};
                    end
                    3'b100: begin
                    //BLT: 如果 rs1 < rs2，则跳转到 PC + imm[12:1]。
                        `signal = {{1'b0},{1'b0},{`NOREGWRITE},{1'b0},{4'b0000},{1'b0},{2'b11},{`BLT},{4'bxxxx},{2'b00},{1'b0},{`BTYPE}};
                    end
                    3'b101: begin
                    //BGE: 如果 rs1 >= rs2，则跳转到 PC + imm[12:1]。
                        `signal = {{1'b0},{1'b0},{`NOREGWRITE},{1'b0},{4'b0000},{1'b0},{2'b11},{`BGE},{4'bxxxx},{2'b00},{1'b0},{`BTYPE}};
                    end
                    3'b110: begin
                    //BLTU: 如果 rs1 < rs2 (无符号比较)，则跳转到 PC + imm[12:1]。
                        `signal = {{1'b0},{1'b0},{`NOREGWRITE},{1'b0},{4'b0000},{1'b0},{2'b11},{`BLTU},{4'bxxxx},{2'b00},{1'b0},{`BTYPE}};
                    end
                    3'b111: begin
                    //BGEU: 如果 rs1 >= rs2 (无符号比较)，则跳转到 PC + imm[12:1]。
                        `signal = {{1'b0},{1'b0},{`NOREGWRITE},{1'b0},{4'b0000},{1'b0},{2'b11},{`BGEU},{4'bxxxx},{2'b00},{1'b0},{`BTYPE}};
                    end 
                endcase
            end
            7'b0000011: begin
            //I型指令:Load类
                case(Fn3)
                    3'b000: begin
                    //LB: 将内存地址 rs1 + imm[11:0] 处的 8 位有符号数加载到寄存器 rd。
                        `signal = {{1'b0},{1'b0},{`LB},{1'b1},{4'b0000},{1'b0},{2'b10},{`NOBRANCH},{`ADD},{2'b10},{1'b0},{`ITYPE}};
                    end
                    3'b001: begin
                    //LH: 将内存地址 rs1 + imm[11:0] 处的 16 位有符号数加载到寄存器 rd。
                        `signal = {{1'b0},{1'b0},{`LH},{1'b1},{4'b0000},{1'b0},{2'b10},{`NOBRANCH},{`ADD},{2'b10},{1'b0},{`ITYPE}};
                    end
                    3'b010: begin
                    //LW: 将内存地址 rs1 + imm[11:0] 处的 32 位有符号数加载到寄存器 rd。
                        `signal = {{1'b0},{1'b0},{`LW},{1'b1},{4'b0000},{1'b0},{2'b10},{`NOBRANCH},{`ADD},{2'b10},{1'b0},{`ITYPE}};
                    end
                    3'b100: begin
                    //LBU: 将内存地址 rs1 + imm[11:0] 处的 8 位无符号数加载到寄存器 rd。
                        `signal = {{1'b0},{1'b0},{`LBU},{1'b1},{4'b0000},{1'b0},{2'b10},{`NOBRANCH},{`ADD},{2'b10},{1'b0},{`ITYPE}};
                    end
                    3'b101: begin
                    //LHU: 将内存地址 rs1 + imm[11:0] 处的 16 位无符号数加载到寄存器 rd。
                        `signal = {{1'b0},{1'b0},{`LHU},{1'b1},{4'b0000},{1'b0},{2'b10},{`NOBRANCH},{`ADD},{2'b10},{1'b0},{`ITYPE}};
                    end
                endcase
            end
            7'b0100011: begin
            //S型指令
                case(Fn3)
                    3'b000: begin
                    //SB: 将寄存器 rs2 中的 8 位有符号数存储到内存地址 rs1 + imm[11:0] 处。
                        `signal = {{1'b0},{1'b0},{`NOREGWRITE},{1'b0},{4'b0001},{1'b0},{2'b11},{`NOBRANCH},{`ADD},{2'b10},{1'b0},{`STYPE}};
                    end
                    3'b001: begin
                    //SH: 将寄存器 rs2 中的 16 位有符号数存储到内存地址 rs1 + imm[11:0] 处。
                        `signal = {{1'b0},{1'b0},{`NOREGWRITE},{1'b0},{4'b0011},{1'b0},{2'b11},{`NOBRANCH},{`ADD},{2'b10},{1'b0},{`STYPE}};
                    end
                    3'b010: begin
                    //SW: 将寄存器 rs2 中的 32 位有符号数存储到内存地址 rs1 + imm[11:0] 处。
                        `signal = {{1'b0},{1'b0},{`NOREGWRITE},{1'b0},{4'b1111},{1'b0},{2'b11},{`NOBRANCH},{`ADD},{2'b10},{1'b0},{`STYPE}};
                    end
                endcase
            end
            7'b0010011: begin
            // I型指令：立即数运算类
                case(Fn3)
                    3'b000: begin
                    //ADDI: 将寄存器 rs1 中的值加上立即数 imm[11:0] 并将结果存储到寄存器 rd。
                        `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b10},{`NOBRANCH},{`ADD},{2'b10},{1'b0},{`ITYPE}};
                    end
                    3'b010: begin
                    //SLTI: 如果寄存器 rs1 中的值小于立即数 imm[11:0]，则将 1 存储到寄存器 rd，否则存储 0。
                        `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b10},{`NOBRANCH},{`SLT},{2'b10},{1'b0},{`ITYPE}};
                    end
                    3'b011: begin
                    //SLTIU: 如果寄存器 rs1 中的值小于立即数 imm[11:0]（无符号比较），则将 1 存储到寄存器 rd，否则存储 0。
                        `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b10},{`NOBRANCH},{`SLTU},{2'b10},{1'b0},{`ITYPE}};
                    end
                    3'b100: begin
                    //XORI: 将寄存器 rs1 中的值与立即数 imm[11:0] 进行异或运算，并将结果存储到寄存器 rd。
                        `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b10},{`NOBRANCH},{`XOR},{2'b10},{1'b0},{`ITYPE}};
                    end
                    3'b110: begin
                    //ORI: 将寄存器 rs1 中的值与立即数 imm[11:0] 进行或运算，并将结果存储到寄存器 rd。
                        `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b10},{`NOBRANCH},{`OR},{2'b10},{1'b0},{`ITYPE}};
                    end
                    3'b111: begin
                    //ANDI: 将寄存器 rs1 中的值与立即数 imm[11:0] 进行与运算，并将结果存储到寄存器 rd。
                        `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b10},{`NOBRANCH},{`AND},{2'b10},{1'b0},{`ITYPE}};
                    end
                    3'b001: begin
                    //SLLI: 将寄存器 rs1 中的值左移 imm[4:0] 位，并将结果存储到寄存器 rd。
                        `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b10},{`NOBRANCH},{`SLL},{2'b10},{1'b0},{`ITYPE}};
                    end
                    3'b101: begin
                        case(Fn7)
                            7'b0000000: begin
                            //SRLI: 将寄存器 rs1 中的值右移 imm[4:0] 位（逻辑右移），并将结果存储到寄存器 rd。
                                `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b10},{`NOBRANCH},{`SRL},{2'b10},{1'b0},{`ITYPE}};
                            end
                            7'b0100000: begin
                            //SRAI: 将寄存器 rs1 中的值右移 imm[4:0] 位（算术右移），并将结果存储到寄存器 rd。
                                `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b10},{`NOBRANCH},{`SRA},{2'b10},{1'b0},{`ITYPE}};
                            end
                        endcase
                    end
                endcase
            end
            7'b0110011: begin
            // R型指令：寄存器运算类
                case(Fn3)
                    3'b000: begin
                        case(Fn7)
                            7'b0000000: begin
                            //ADD: 将寄存器 rs1 中的值与寄存器 rs2 中的值相加，并将结果存储到寄存器 rd。
                                `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b11},{`NOBRANCH},{`ADD},{2'b00},{1'b0},{`RTYPE}};
                            end
                            7'b0100000: begin
                            //SUB: 将寄存器 rs1 中的值减去寄存器 rs2 中的值，并将结果存储到寄存器 rd。
                                `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b11},{`NOBRANCH},{`SUB},{2'b00},{1'b0},{`RTYPE}};
                            end
                        endcase
                    end
                    3'b001: begin
                    //SLL: 将寄存器 rs1 中的值左移寄存器 rs2 中的值指定的位数，并将结果存储到寄存器 rd。
                        `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b11},{`NOBRANCH},{`SLL},{2'b00},{1'b0},{`RTYPE}};
                    end
                    3'b010: begin
                    //SLT: 如果寄存器 rs1 中的值小于寄存器 rs2 中的值，则将 1 存储到寄存器 rd，否则存储 0。
                        `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b11},{`NOBRANCH},{`SLT},{2'b00},{1'b0},{`RTYPE}};
                    end
                    3'b011: begin
                    //SLTU: 如果寄存器 rs1 中的值小于寄存器 rs2 中的值（无符号比较），则将 1 存储到寄存器 rd，否则存储 0。
                        `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b11},{`NOBRANCH},{`SLTU},{2'b00},{1'b0},{`RTYPE}};
                    end
                    3'b100: begin
                    //XOR: 将寄存器 rs1 中的值与寄存器 rs2 中的值进行异或运算，并将结果存储到寄存器 rd。
                        `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b11},{`NOBRANCH},{`XOR},{2'b00},{1'b0},{`RTYPE}};
                    end
                    3'b101: begin
                        case(Fn7)
                            7'b0000000: begin
                            //SRL: 将寄存器 rs1 中的值右移寄存器 rs2 中的值指定的位数（逻辑右移），并将结果存储到寄存器 rd。
                                `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b11},{`NOBRANCH},{`SRL},{2'b00},{1'b0},{`RTYPE}};
                            end
                            7'b0100000: begin
                            //SRA: 将寄存器 rs1 中的值右移寄存器 rs2 中的值指定的位数（算术右移），并将结果存储到寄存器 rd。
                                `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b11},{`NOBRANCH},{`SRA},{2'b00},{1'b0},{`RTYPE}};
                            end
                        endcase
                    end
                    3'b110: begin
                    //OR: 将寄存器 rs1 中的值与寄存器 rs2 中的值进行或运算，并将结果存储到寄存器 rd。
                        `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b11},{`NOBRANCH},{`OR},{2'b00},{1'b0},{`RTYPE}};
                    end
                    3'b111: begin
                    //AND: 将寄存器 rs1 中的值与寄存器 rs2 中的值进行与运算，并将结果存储到寄存器 rd。
                        `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b11},{`NOBRANCH},{`AND},{2'b00},{1'b0},{`RTYPE}};
                    end
                endcase
            end
            default: begin
                `signal = {{1'b0},{1'b0},{`LW},{1'b0},{4'b0000},{1'b0},{2'b00},{`NOBRANCH},{`ADD},{2'b00},{1'b0},{`RTYPE}};
            end
        endcase
    end
endmodule


//功能说明
    //ControlUnit       是本CPU的指令译码器，组合逻辑电路
//输入
    // Op               是指令的操作码部分
    // Fn3              是指令的func3部分
    // Fn7              是指令的func7部分
//输出
    // JalD==1          表示Jal指令到达ID译码阶段
    // JalrD==1         表示Jalr指令到达ID译码阶段
    // RegWriteD        表示ID阶段的指令对应的 寄存器写入模式 ，所有模式定义在Parameters.v中
    // MemToRegD==1     表示ID阶段的指令需要将data memory读取的值写入寄存器,
    // MemWriteD        共4bit，采用独热码格式，对于data memory的32bit字按byte进行写入,MemWriteD=0001表示只写入最低1个byte，和xilinx bram的接口类似
    // LoadNpcD==1      表示将NextPC输出到ResultM
    // RegReadD[1]==1   表示A1对应的寄存器值被使用到了，RegReadD[0]==1表示A2对应的寄存器值被使用到了，用于forward的处理
    // BranchTypeD      表示不同的分支类型，所有类型定义在Parameters.v中
    // AluContrlD       表示不同的ALU计算功能，所有类型定义在Parameters.v中
    // AluSrc2D         表示Alu输入源2的选择
    // AluSrc1D         表示Alu输入源1的选择
    // ImmType          表示指令的立即数格式，所有类型定义在Parameters.v中   
//实验要求  
    //实现ControlUnit模块   
