module traffic_light (clk,rst,pass,R,G,Y);
//write your code here

input  clk;
input  rst;
input  pass;
output R;
output G;
output Y;
reg R,G,Y;
reg [15:0]count;

always@(posedge clk or posedge rst)
begin
if (rst)
	begin
	count=16'd0;
	R=0;
	G=1;
	Y=0;
	end
else	
	begin
	if(pass)
		begin
		if(count>=16'd1024)//not first step G
			begin
			R=0;
			G=1;
			Y=0;
			count=0;
			end
		else
			begin
			count=count+1;
			end
		end
	else//count continue
		count = count + 16'd1;
		begin
		if(count==16'd3072)
			begin
			count=0;
			R=0;
			G=1;
			Y=0;
			end
		else if(count<16'd1024)//G
			begin
			R=0;
			G=1;
			Y=0;
			end
		else if(count<16'd1152&&count>=16'd1024)//N
			begin
			R=0;
			G=0;
			Y=0;
			end
		else if(count<16'd1280&&count>=16'd1152)//G
			begin
			R=0;
			G=1;
			Y=0;
			end
		else if(count<16'd1408&&count>=16'd1280)//N
			begin
			R=0;
			G=0;
			Y=0;
			end
		else if(count<16'd1536&&count>=16'd1408)//G
			begin
			R=0;
			G=1;
			Y=0;
			end
		else if(count<16'd2048&&count>=16'd1536)//Y
			begin
			R=0;
			G=0;
			Y=1;
			end
		else if(count<16'd3072&&count>=16'd2048)//R
			begin
			R=1;
			G=0;
			Y=0;
			end
		else
			begin	
			count=count;
			end
		end
	end
end
endmodule
