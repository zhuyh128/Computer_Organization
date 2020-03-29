#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <math.h>
#include <time.h>  
using namespace std;
int lru[999999][50];
int usebit[999999][50];
//Function to change the tag order in the lru algo
int lrup(int set, int assoc, int pos)
{
    int i,k;
    for(i=0;i<assoc;i++){
        if(lru[set][i] == pos){
            k = i;
		}
	}
    for(i=k;i<assoc-1;i++){
        lru[set][i] = lru[set][i+1];
	}
    lru[set][assoc-1] = pos;
}

int main(int argc,char *argv[])
{
	fstream fin;
	char* f1=argv[1];
	char* f2=argv[2];
	string F1;
	string F2;
	F1.assign(f1);
	F2.assign(f2);
	//F1=F1.substr(2);
	//F2=F2.substr(2);
	//cout<<F1;//<<" "<<F2;
	
    fin.open(F1.c_str(),ios::in);
    fstream fout;
   	fout.open(F2.c_str(),ios::out) ;
	long int csize;
	long int bsize;
	string asso;
	string policy;
	string line;
	int pos;
	int c=0;
	vector <string> temp;
	string t;

	while(getline(fin, line))
	{
		c=c+1;
		if(c==1){
			//cout<<c<<endl;
			csize=atoi(line.c_str());//(KB)
			csize=csize*1024;
			//cout<<csize<<endl;
		}
		else if(c==2){
			//cout<<c<<endl;
			bsize=atoi(line.c_str());
			//bsize=bsize*4;
		} 
		else if(c==3){
			//cout<<c<<endl;
			asso=line.c_str();
		}
		else if(c==4){
			//cout<<c<<endl;
			policy=line.c_str();
		}
		else{
		t=line.c_str();
		//cout<<temp.size()<<endl;
		temp.push_back(t);
		//cout<<temp[c-5]<<endl;
		}
	}
	//cout<<csize<<endl<<bsize<<endl<<asso<<endl<<policy<<endl;
	//cout<<temp.size();
	//cout<<asso<<endl;
	
	if(asso=="1"){// four-way set 
		//cout<<"four-way set associative"<<endl; 
		int bn=csize/bsize;//number of block
		int sn=csize/(bsize*4);
		//cout<<bn<<" "<<sn;//32 8
		string x=F1.substr(5,1);
		//cout<<x<<endl;
		int u=atoi(x.c_str());
    	int cache[sn][4];
    	for(int m=0;m<sn;m++){
			for(int n=0;n<4;n++){
				cache[m][n] =-10;	
			}
		}
		int fifo[sn];
		for(int m=0;m<sn;m++){
			fifo[m] = 0;	
		}
		for(int m=0;m<sn;m++){
			for(int n=0;n<4;n++){
				lru[m][n] =n;
			}
		} 
		for(int m=0;m<sn;m++){
			for(int n=0;n<4;n++){
				usebit[m][n] =0;
			}
		} 
		int test[sn];
		for(int m=0;m<sn;m++){
			test[m] = 0;	
		}
		int victimptr=0;
		for (int k=0;k<temp.size();k++){
			int found=0;
			string tt=temp[k];
			char c[tt.length()];
    		for(int i=0; i<tt.length(); i++){
          		c[i] = tt[i];
      		}
			long long int address=strtoul(c,NULL,16);
			int i=(address/bsize)%sn;
			int tagn=address / (bsize*sn);
			int z=0;
			for(int q=0;q<4;q++){
    			if(cache[i][q]==tagn){
					fout<<-1<<endl;
					found = 1;
        			pos = q;
        			break;
				}
			}	
  			if(found!=1){
				for(int q=0;q<bn;q++){
    				if(cache[i][q]==-10){
						fout<<-1<<endl;
						cache[i][q]=tagn;
						found = 1;
        				pos = q;
        				break;
					}
				}
			}
			if(found){
      			if(policy=="1"){
                	lrup(i,4,pos);
      			}
				else if(policy=="2"){
					if(usebit[i][pos]==0){
                		usebit[i][pos]=1;
					}
      			}
  			}
  			else{
            	if(policy=="0"){//FIFO
             		z= fifo[i];
             		fout<<cache[i][z]<<endl;
   					cache[i][z] = tagn;
   					fifo[i]++;
   					if(fifo[i] == 4)
    				fifo[i] = 0;
				}
           		else if(policy=="1"){//LRU
                	z= lru[i][0];
                	fout<<cache[i][z]<<endl;
                	cache[i][z] = tagn;
                	lrup(i,4,z);
            	}
            	else{//Mypolicy
					if(u!=4){
						z= usebit[i][victimptr];
						fout<<cache[i][z]<<endl;
   						cache[i][z] = tagn;
						if(usebit[i][victimptr]==1){
                			do{
                    		usebit[i][victimptr]=0;
                    		victimptr++;
                    		if(victimptr==4)
                        		victimptr=0;
                			}while(usebit[i][victimptr]!=0);
            			}
            			if(usebit[i][victimptr]==0){
                			usebit[i][victimptr]=1;
                			victimptr++;
            			}						
					}
					else{
						z= test[i];
             			fout<<cache[i][z]<<endl;
   						cache[i][z] = tagn;
   						test[i]--;
   						if(test[i] == -1){
    						test[i] =3;	
						}
					}
				}
  			}
		}
	}
	else if(asso=="2"){//fully associative
		//cout<<"fully associative"<<endl; 
		int bn=csize/bsize;//number of block
		int sn=1;
    	int cache[sn][bn];
    	for(int m=0;m<sn;m++){
			for(int n=0;n<bn;n++){
				cache[m][n] =-10;	
			}
		}
		int fifo[sn];
		for(int m=0;m<sn;m++){
			fifo[m] = 0;	
		}
		for(int m=0;m<sn;m++){
			for(int n=0;n<bn;n++){
				lru[m][n] =n;
			}
		}
		for(int m=0;m<sn;m++){
			for(int n=0;n<bn;n++){
				usebit[m][n] =0;
			}
		}
		int victimptr=0;
		//cout<<temp.size();//999995
		for (int k=0;k<temp.size();k++){
			int found=0;
			string tt=temp[k];
			char c[tt.length()];
    		for(int i=0; i<tt.length(); i++){
          		c[i] = tt[i];
      		}
			long long int address=strtoul(c,NULL,16);
			int i=(address/bsize)%sn;
			int tagn=address / (bsize*sn);
			int z=0;
			for(int q=0;q<bn;q++){
    			if(cache[i][q]==tagn){
					fout<<-1<<endl;
					found = 1;
        			pos = q;
        			break;
				}
			}	
			if(found==0){
				for(int q=0;q<bn;q++){
    				if(cache[i][q]==-10){
						fout<<-1<<endl;
						cache[i][q]=tagn;
						found = 1;
        				pos = q;
        				break;
					}
				}
			}
			
			if(found==1){
      			if(policy=="1"){
                	lrup(i,bn,pos);
      			}
				else if(policy=="2"){
					if(usebit[i][pos]==0){
                		usebit[i][pos]=1;
					}
      			}
  			}
  			else{
            	if(policy=="0"){//FIFO
             		z = fifo[i];
             		fout<<cache[i][z]<<endl;
   					cache[i][z] = tagn;
   					fifo[i]++;
   					if(fifo[i] == bn){
   						fifo[i] = 0;	
					}
				}
           		else if(policy=="1"){//LRU
                	z = lru[i][0];
                	fout<<cache[i][z]<<endl;
                	cache[i][z] = tagn;
                	lrup(i,bn,z);
            	}
            	else{ 
					z= usebit[i][victimptr];
					fout<<cache[i][z]<<endl;
   					cache[i][z] = tagn;
					if(usebit[i][victimptr]==1){
                		do{
                    	usebit[i][victimptr]=0;
                    	victimptr++;
                    	if(victimptr==4)
                        	victimptr=0;
                		}while(usebit[i][victimptr]!=0);
            		}
            		if(usebit[i][victimptr]==0){
                		usebit[i][victimptr]=1;
                		victimptr++;
            		}
				}
  			}
		}
	}
	else{
    	//cout<<"direct-mapped"<<endl; 
    	int bn=csize/bsize;//number of block 
    	int sn=bn/1;//set num=block num // bn/1 
    	int cache[sn][2];
    	for(int m=0;m<sn;m++){
			for(int n=0;n<2;n++){
				cache[m][n] =-10;	
			}
		}
		for (int k=0;k<temp.size();k++){
			string tt=temp[k];
			char c[tt.length()];
    		for(int i=0; i<tt.length(); i++){
          		c[i] = tt[i];
      		}
			long long int address=strtoul(c,NULL,16);
			int i=(address/bsize)%sn;
			int tagn=address / (bsize*sn);
			if(cache[i][0]==-10){
				cache[i][0]=1;
				cache[i][1]=tagn;
				fout<<-1<<endl;
			}
			else{//exist someone
				if(cache[i][1]==tagn){
					//cout<<"something"<<endl;
					fout<<-1<<endl;
				}
				else{
					//cout<<"wow"<<endl;
					fout<<cache[i][1]<<endl;
					cache[i][1]=tagn;	
				}
			}
		}
	}	
	fin.close();
	fout.close();
	
	return 0;
}
