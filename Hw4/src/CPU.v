module CPU(
    input         clk,
    input         rst,
    output reg      instr_read,
    output reg [31:0] instr_addr,
    input  [31:0] instr_out,
    output reg       data_read,
    output reg       data_write,
    output reg [31:0] data_addr,
    output reg [31:0] data_in,
    input  [31:0] data_out
);

reg [31:0] regarray[31:0];
reg [31:0] rd1,rd2;
reg [4:0] writereg;
reg [31:0] immdata;
integer i;

initial begin
    instr_read = 1;
    data_write = 0;
    data_read = 0;
    instr_addr = 0;
    instr_addr=0;
    for(i = 0; i<32; i = i + 1)
	begin
	    regarray[i] = 0;
	end
end

always@(posedge clk)
begin 
    if(data_read == 1)
    begin
	    regarray[writereg] = data_out;
        data_read=0;
    end
    instr_read = 1;
    data_read = 0;
    data_write = 0;
    writereg = 0;

    if(rst == 1)
    begin
        instr_read=1;
        instr_addr=0;
        data_read=0;
        data_write=0;
        data_addr=0;
        data_in=0;
        immdata=0; 
        for (i =0 ;i<=31 ;i=i+1 ) 
        begin
            regarray[i]=0;
        end
    end
    rd1 = regarray[instr_out[19:15]];
    rd2 = regarray[instr_out[24:20]];

    if(instr_out[6:0] == 7'b0110011)      //R   
    begin
    //$display("R");
        if(instr_out[31:25]==7'b0000000&&instr_out[14:12]==3'b000)//add
        begin
            regarray[instr_out[11:7]] = rd1+rd2;
        end
        else if(instr_out[31:25]==7'b0100000&&instr_out[14:12]==3'b000)//sub
        begin
            regarray[instr_out[11:7]] = rd1-rd2;
        end
        else if(instr_out[31:25]==7'b0000000&&instr_out[14:12]==3'b001)//sll
        begin
            regarray[instr_out[11:7]] = rd1<<rd2[4:0];
        end
        else if(instr_out[31:25]==7'b0000000&&instr_out[14:12]==3'b010)//slt
        begin
            if($signed(rd1) < $signed(rd2))
            begin
                regarray[instr_out[11:7]] =1;
            end
            else
            begin
                regarray[instr_out[11:7]] =0;
            end
        end
        else if(instr_out[31:25]==7'b0000000&&instr_out[14:12]==3'b011)//sltu
        begin
            if(rd1<rd2)
            begin
                regarray[instr_out[11:7]] =1;
            end
            else
            begin
                regarray[instr_out[11:7]] =0;
            end
        end
        else if(instr_out[31:25]==7'b0000000&&instr_out[14:12]==3'b100)//xor
        begin
            regarray[instr_out[11:7]] = rd1^rd2;
        end
        else if(instr_out[31:25]==7'b0000000&&instr_out[14:12]==3'b101)//srl
        begin
            regarray[instr_out[11:7]] = rd1>>rd2[4:0];
        end
        else if(instr_out[31:25]==7'b0100000&&instr_out[14:12]==3'b101)//sra
        begin
            regarray[instr_out[11:7]] = $signed(rd1)>>>rd2[4:0];
        end
        else if(instr_out[31:25]==7'b0000000&&instr_out[14:12]==3'b110)//or
        begin
            regarray[instr_out[11:7]] = rd1|rd2;
        end
        else if(instr_out[31:25]==7'b0000000&&instr_out[14:12]==3'b111)//and
        begin
            regarray[instr_out[11:7]] = rd1&rd2;
        end
	    instr_addr = instr_addr + 32'd4;
	    regarray[0] = 0;
    end
    else if(instr_out[6:0]==7'b0000011)//lw
    begin
    //$display("lw");
    //dataread=1 每回合檢查dataread dataout=>
    //rd = M[rs1 + imm] 
        if(instr_out[31]==1)
        begin
            immdata={20'b11111111111111111111,instr_out[31:20]};
        end
        else
        begin
            immdata={20'b00000000000000000000,instr_out[31:20]};
        end
        writereg=instr_out[11:7];//rd_addr
        instr_addr=instr_addr+32'd4;
        data_read=1;
        data_addr=rd1+immdata;
    end
    else if( instr_out[6:0] == 7'b0010011 )//I
    begin
    //$display("I");
	    if(instr_out[31]==1)
        begin
            immdata={20'b11111111111111111111,instr_out[31:20]};
        end
        else
        begin
            immdata={20'b00000000000000000000,instr_out[31:20]};
        end
        if(instr_out[14:12]==3'b000)
        begin
            regarray[instr_out[11:7]] = rd1+immdata;//addi
        end
        else if(instr_out[14:12]==3'b010)
        begin
            regarray[instr_out[11:7]] = ($signed(rd1)<$signed(immdata))? 1:0;//slti
        end
        else if(instr_out[14:12]==3'b011)
        begin
            regarray[instr_out[11:7]] = (rd1<immdata)? 1:0;//sltiu
        end
        else if(instr_out[14:12]==3'b100)
        begin
            regarray[instr_out[11:7]] = rd1^immdata;//xori
        end    
        else if(instr_out[14:12]==3'b110)
        begin
            regarray[instr_out[11:7]] = rd1|immdata;//ori
        end     
        else if(instr_out[14:12]==3'b111)
        begin
            regarray[instr_out[11:7]] = rd1&immdata;//andi
        end    
        else if(instr_out[14:12]==3'b001)
        begin
            regarray[instr_out[11:7]] = rd1<<instr_out[24:20];//slli
        end     
        else if(instr_out[14:12]==3'b101)
        begin
            if (instr_out[31:25] == 7'b0000000) 
            begin
                regarray[instr_out[11:7]] = rd1>>instr_out[24:20];//srli
            end 
            else 
            begin
                regarray[instr_out[11:7]] = $signed(rd1)>>>instr_out[24:20];//srai
            end
        end    
	    instr_addr = instr_addr + 4;
    end

    else if(instr_out[6:0]==7'b0100011)//sw
    begin
    //$display("SW");
        if(instr_out[31]==1)
        begin
            immdata={20'b11111111111111111111,instr_out[31:25],instr_out[11:7]};
        end
        else
        begin
            immdata={20'b00000000000000000000,instr_out[31:25],instr_out[11:7]};
        end
        data_addr=rd1+immdata;
        data_in=rd2;
        instr_addr=instr_addr+32'd4;
        data_write=1;
    end 
    else if(instr_out[6:0]==7'b1100111)//jalr
    begin
    //$display("JALR");
    //rd = PC + 4 ,PC = imm + rs1 (Set LSB of PC to 0) 
        if(instr_out[31]==1)
        begin
            immdata={20'b11111111111111111111,instr_out[31:20]};
        end
        else
        begin
            immdata={20'b00000000000000000000,instr_out[31:20]};
        end
        regarray[instr_out[11:7]] = instr_addr + 4;
	    instr_addr = immdata + rd1;
	    instr_addr[0] = 0;
    end

    else if(instr_out[6:0]==7'b1100011)//b type
    begin
    //$display("B");
        if(instr_out[31]==1)
        begin
            immdata={19'b1111111111111111111,instr_out[31],instr_out[7],instr_out[30:25],instr_out[11:8],1'b0};
        end
        else
        begin
            immdata={19'b0000000000000000000,instr_out[31],instr_out[7],instr_out[30:25],instr_out[11:8],1'b0};
        end
        if(instr_out[14:12]==3'b000)//beq
        begin
            if(rd1==rd2)
            begin
                instr_addr=instr_addr+immdata;
            end
            else
            begin
                instr_addr=instr_addr+32'd4;
            end
        end
        else if(instr_out[14:12]==3'b001)//bne
        begin
            if(rd1!=rd2)
            begin
                instr_addr=instr_addr+immdata;
            end
            else
            begin
                instr_addr=instr_addr+32'd4;
            end
        end
        else if(instr_out[14:12]==3'b100)//blt
        begin
            if($signed(rd1)<$signed(rd2))
            begin
                instr_addr=instr_addr+immdata;
            end
            else
            begin
                instr_addr=instr_addr+32'd4;
            end
        end
        else if(instr_out[14:12]==3'b101)//bge
        begin
            if($signed(rd1)>=$signed(rd2))
            begin
               instr_addr=instr_addr+immdata;
            end
            else
            begin
                instr_addr=instr_addr+32'd4;
            end
        end
        else if(instr_out[14:12]==3'b110)//bltu
        begin
            if(rd1<rd2)
            begin
                instr_addr=instr_addr+immdata;
            end
           else
           begin
                instr_addr=instr_addr+32'd4;
            end
        end
        else if(instr_out[14:12]==3'b111)//bgeu
        begin
            if(rd1>=rd2)
            begin
                instr_addr=instr_addr+immdata;
            end
            else
            begin
               instr_addr=instr_addr+32'd4;
            end
        end
    end
    else if(instr_out[6:0]==7'b0010111)//AUIPC
    begin
    //$display("AUIPC");
    //rd = PC + imm 
        immdata={instr_out[31:12],12'b000000000000};
        regarray[instr_out[11:7]]=instr_addr+immdata;
        instr_addr=instr_addr+32'd4;
    end
    else if(instr_out[6:0]==7'b0110111)//LUI
    begin
        //$display("LUI");
        //rd = imm
        immdata={instr_out[31:12],12'b000000000000};
        regarray[instr_out[11:7]]=immdata;
        instr_addr=instr_addr+32'd4;
    end
    else if(instr_out[6:0]==7'b1101111)//JAL
    begin
    //$display("JAL");
    //rd = PC + 4 
    //PC = PC + imm
        if(instr_out[31]==1)
        begin
            immdata={11'b11111111111,instr_out[31],instr_out[19:12],instr_out[20],instr_out[30:21],1'b0};
        end
        else
        begin
            immdata={11'b00000000000,instr_out[31],instr_out[19:12],instr_out[20],instr_out[30:21],1'b0};
        end
        regarray[instr_out[11:7]]=instr_addr+32'd4;
        instr_addr=instr_addr+immdata;
    end 
    else
    begin
        
    end
    regarray[0] = 0;
end
endmodule