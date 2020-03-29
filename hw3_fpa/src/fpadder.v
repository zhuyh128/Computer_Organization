module fpadder (src1,src2,out);
    // -------------------------------------- //
    //   \^o^/   Write your code here~  \^o^/ //
	input  [31:0] src1;
    input  [31:0] src2;
    output reg	[31:0] out;
	reg s1;
	reg s2;
    reg [7:0] e1;
    reg [7:0] e2;
	reg [7:0] es;
    reg [46:0] f1;//1b+23+g+r+s(23)
    reg [46:0] f2;
 	reg [47:0] fs;
	reg [7:0] diff;
	reg ss;
	reg guard,round;
	reg sticky;

	always@(src1,src2)
	begin	
		f1=0;f2=0;fs=0;diff=0;
		
		s1=src1[31];
		if(src1[30:23]==0)
		begin 
   			e1 = 8'b00000001;
			f1 = {1'b0, src1[22:0],23'b0};
		end
		else
		begin 
    		e1 = src1[30:23];
			f1 = {1'b1, src1[22:0],23'b0};
		end
		
		s2=src2[31];
		if(src2[30:23]==0)
		begin
   			e2=8'b00000001;
			f2={1'b0, src2[22:0],23'b0};
		end
		else
		begin
    		e2=src2[30:23];
			f2={1'b1, src2[22:0],23'b0};
		end
		
		if(e1==e2) 
		begin
			es=e1;
        	if (s1==s2) 
			begin
        		fs=f1+f2;
        		ss=s1;
        	end 
			else 
			begin 
        		if(f1>f2) 
				begin
        			fs=f1-f2;
        	  		ss=s1;
        		end 
				else //if(f2>f1) 
				begin
        	    	fs=f2-f1;
        	    	ss=s2;
        	    end
      		end
    	end
		else
		begin
			if(e1>e2) 	
			begin
				es=e1;
				ss=s1;
				diff=e1-e2;
				f2=f2>>diff;
    		 	if (s1==s2)
    		 	   	fs=f1+f2;
    		    else
    		   		fs=f1-f2;
			end 
			else 	
			begin
  				es=e2;
				ss=s2;
				diff=e2-e1;	
				f1=f1>>diff;
				if (s1==s2)
    		    	fs=f2+f1;
    		    else
    		      	fs=f2-f1;
			end
		end

		if(fs[47:46]!=2'b01)//no normalize
		begin
			if(fs[47]==1)
			begin
    			es=es+1;
				fs=fs>>1;
			end
	    	else if((fs[46]==0))
			begin 
				if (fs[46:23] == 24'b000000000000000000000001) 
				begin 
					es = es - 23;
					fs = fs << 23;
				end 
				else if (fs[46:24] == 23'b00000000000000000000001) 
				begin 
					es = es - 22;
					fs = fs << 22;
				end 
				else if (fs[46:25] == 22'b0000000000000000000001) 
				begin 
					es = es - 21;
					fs = fs << 21;
				end 
				else if (fs[46:26] == 21'b000000000000000000001) 
				begin 
					es = es - 20;
					fs = fs << 20;
				end 
				else if (fs[46:27] == 20'b00000000000000000001) 
				begin
					es = es - 19;
					fs= fs<<19;
				end 
				else if (fs[46:28] == 19'b0000000000000000001) 
				begin
					es = es- 18;
					fs = fs << 18;
				end 
				else if (fs[46:29] == 18'b000000000000000001) 
				begin
					es = es - 17;
					fs =fs << 17;
				end 
				else if (fs[46:30] == 17'b00000000000000001) 
				begin
					es = es - 16;
					fs =fs << 16;
				end 
				else if (fs[46:31] == 16'b0000000000000001) 
				begin
					es = es - 15;
					fs =fs << 15;
				end 
				else if (fs[46:32] == 15'b000000000000001) 
				begin
					es = es - 14;
					fs =fs << 14;
				end 
				else if (fs[46:33] == 14'b00000000000001) 
				begin
					es = es - 13;
					fs =fs << 13;
				end 
				else if (fs[46:34] == 13'b0000000000001) 
				begin
					es = es - 12;
					fs =fs << 12;
				end 
				else if (fs[46:35] == 12'b000000000001) 
				begin
					es = es - 11;
					fs =fs << 11;
				end 
				else if (fs[46:36] == 11'b00000000001) 
				begin
					es= es - 10;
					fs=fs << 10;
				end 
				else if (fs[46:37] == 10'b0000000001) 
				begin
					es= es - 9;
					fs=fs << 9;
				end 
				else if (fs[46:38] == 9'b000000001) 
				begin
					es= es - 8;
					fs=fs << 8;
				end 
				else if(fs[46:39] == 8'b00000001) 
				begin
					es= es - 7;
					fs=fs << 7;
				end 
				else if(fs[46:40] == 7'b0000001) 
				begin
					es=es - 6;
					fs=fs << 6;
				end 
				else if(fs[46:41] == 6'b000001) 
				begin
					es=es-5;
					fs=fs << 5;
				end 
				else if(fs[46:42] == 5'b00001) 
				begin
					es = es - 4;
					fs =fs << 4;
				end 
				else if (fs[46:43] == 4'b0001) 
				begin
					es = es - 3;
					fs =fs << 3;
				end 
				else if (fs[46:44] == 3'b001) 
				begin
					es = es - 2;
					fs =fs << 2;
				end 
				else if (fs[46:45] == 2'b01) 
				begin
					es = es - 1;
					fs =fs << 1;
				end
				else
				begin
					es=es;
					fs=fs;
				end
			end
		end
		else
		begin
		end	
//rounding
		guard=fs[22];
		round=fs[21];
		if(fs[20:0]==0)
			sticky=0;
		else
			sticky=1;
		if((guard==1))
		begin
			if(round==1||sticky==1)
			begin
				fs=fs+24'b100000000000000000000000;	
			end
			else
			begin
				if(fs[23]==0)
					fs=fs;
				else
					fs=fs+24'b100000000000000000000000;	
			end
		end
		else
		begin
			fs=fs;
		end
//output
		if(fs[45:23]==0)//zero
		begin
			out[31] = 0;
			out[30:23] = 0;
 			out[22:0] = 0;
		end
		else if(es==255)//infinity
		begin
			out[31] = ss;
			out[30:23] = es;
 			out[22:0] = 0;	
		end
		else //normal
		begin
			out[31] = ss;
			out[30:23] = es;
 			out[22:0] = fs[45:23];	
		end
	end
    // -------------------------------------- //
endmodule

