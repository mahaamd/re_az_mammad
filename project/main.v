

module carry_select_adder(input [8:0] A,B,input cin,output [8:0] S,output cout);
        

	wire [8:0] temp0, temp1, carry0 ,carry1;
	
	// input a,b,cin,output sum,carry
	
	//for carry 0
	fulladder fa00(A[0],B[0],1'b0,temp0[0],carry0[0]);
	fulladder fa01(A[1],B[1],carry0[0],temp0[1],carry0[1]);
	fulladder fa02(A[2],B[2],carry0[1],temp0[2],carry0[2]);
	fulladder fa03(A[3],B[3],carry0[2],temp0[3],carry0[3]);
	
	fulladder fa04(A[4],B[4],carry0[3],temp0[4],carry0[4]);
	fulladder fa05(A[5],B[5],carry0[4],temp0[5],carry0[5]);
	fulladder fa06(A[6],B[6],carry0[5],temp0[6],carry0[6]);
	fulladder fa07(A[7],B[7],carry0[6],temp0[7],carry0[7]);
	
	

	//for carry 1
	fulladder fa10(A[0],B[0],1'b1,temp1[0],carry1[0]);
	fulladder fa11(A[1],B[1],carry1[0],temp1[1],carry1[1]);
	fulladder fa12(A[2],B[2],carry1[1],temp1[2],carry1[2]);
	fulladder fa13(A[3],B[3],carry1[2],temp1[3],carry1[3]);
	
	fulladder fa14(A[4],B[4],carry1[3],temp1[4],carry1[4]);
	fulladder fa15(A[5],B[5],carry1[4],temp1[5],carry1[5]);
	fulladder fa16(A[6],B[6],carry1[5],temp1[6],carry1[6]);
	fulladder fa17(A[7],B[7],carry1[6],temp1[7],carry1[7]);
	

	//mux for carry
	multiplexer2 mux_carry(carry0[8],carry1[8],cin,cout);
	//mux's for sum
	multiplexer2 mux_sum0(temp0[0],temp1[0],cin,S[0]);
	multiplexer2 mux_sum1(temp0[1],temp1[1],cin,S[1]);
	multiplexer2 mux_sum2(temp0[2],temp1[2],cin,S[2]);
	multiplexer2 mux_sum3(temp0[3],temp1[3],cin,S[3]);
	multiplexer2 mux_sum4(temp0[4],temp1[4],cin,S[4]);
	multiplexer2 mux_sum5(temp0[5],temp1[5],cin,S[5]);
	multiplexer2 mux_sum6(temp0[6],temp1[6],cin,S[6]);
	multiplexer2 mux_sum7(temp0[7],temp1[7],cin,S[7]);
	
endmodule


module cpu(pc, AC);
	
	output reg [8:0]AC;
	input [4:0]pc;
	reg [7:0]mem[0:31];
	reg [4:0]ar;
	reg [7:0]ir;
	reg [8:0]temp;
	output E;
	reg carry;
	
	integer i , j;
	
	always@(pc)
	begin
		AC = 0;
		for(i = 0; i< 31; i=i+1)
		begin
				mem[i] = i + 3;
		end
		mem[pc] = 8'b00000110;
		ar = pc;// 00001
		//pc[0] =pc[0] + 5'b00001;
		ir = mem[ar];
		//$display(ir);
		// ir == 000 0101
		// input [8:0] A,B,input cin,output [8:0] S,output cout
		case({ir[6], ir[5]})
			2'b00:				
				if(ir[7] == 0)
				begin
					carry = 0;
					carry_select_adder csa(AC, mem[{ir[4], ir[3], ir[2], ir[1], ir[0]}], carry, AC, E);
					//AC =AC + mem[{ir[4], ir[3], ir[2], ir[1], ir[0]}];
				//	mem[{ir[4], ir[3], ir[2], ir[1], ir[0]}] = temp;
				//	AC = AC + AC;
				end
				
				else if(ir[7] == 1)
				begin
					AC = AC + mem[mem[{ir[4], ir[3], ir[2], ir[1], ir[0]}]];
					mem[mem[{ir[4], ir[3], ir[2], ir[1], ir[0]}]] = temp;
				end
				
			2'b01:
				begin
					if(ir[7] == 0)
					begin
						temp = 2*mem[{ir[4], ir[3], ir[2], ir[1], ir[0]}];
						mem[{ir[4], ir[3], ir[2], ir[1], ir[0]}] = temp;
					//	AC = AC + AC;
					end
					
					else if(ir[7] == 1)
					begin
						temp = 2* mem[mem[{ir[4], ir[3], ir[2], ir[1], ir[0]}]];
						mem[mem[{ir[4], ir[3], ir[2], ir[1], ir[0]}]] = temp;
						$display(mem[mem[{ir[4], ir[3], ir[2], ir[1], ir[0]}]]);
					end
				end
			2'b10:
				begin
					if(ir[7] == 0)
					begin
						AC = mem[{ir[4], ir[3], ir[2], ir[1], ir[0]}];
					end
					else if(ir[7] == 1)
					begin
						AC = mem[mem[{ir[4], ir[3], ir[2], ir[1], ir[0]}]];
					end
				end
			
			2'b11:
				begin
					//$display(ir);
					for(i = 0; i < 5; i = i + 1) 
					begin
						ir[i] = ~ir[i];
					end
					$display(ir);
				end
		endcase
	end
	
endmodule

module cpu_tb;
	
	wire [8:0]AC;
	reg [4:0]pc;
	cpu cp(pc, AC);
	
	initial begin
		pc = 5'b00001;
		#10
		pc = 5'b00011;
	end
 

endmodule


module fulladder(input a,b,cin,output sum,carry);

	assign sum = a ^ b ^ cin;
	assign carry = (a & b) | (cin & b) | (a & cin);

	endmodule

module multiplexer2 (input i0,i1,sel,output reg bitout);

	always@(i0,i1,sel)
	begin
	if(sel == 0)
		bitout = i0;
	else
		bitout = i1; 
	end

endmodule


