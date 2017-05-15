`timescale 1ns / 1ps
// EEM16 - Logic Design
// Design Assignment #1 - Problem #1
// dassign1_1.v
module inverter(y,a);
    output y;
    input a;
  
  	wire y;
  	assign y = ~a;
  
endmodule

module nand2(y,a,b);
    output y;
	input a,b;

  	wire y;
  	assign y = ~(a & b);
  
endmodule

module nand3(y,a,b,c);
  	output y;
  	input a,b,c;

  	wire y;
  	assign y = ~(a & b & c);
  
endmodule

module nor2(y,a,b);
  	output y;
  	input a,b;

  	wire y;
 	assign y = ~(a | b);
  
endmodule

module nor3(y,a,b,c);
  	output y;
  	input a,b,c;

  	wire y;
  	assign y = ~(a | b | c);
  
endmodule

module mux2(y,a,b,sel);
  	output y;
  	input a,b,sel;

  	wire y;
  	assign y = (sel) ? a : b;
  
endmodule

module xor2(y,a,b);
  	output y;
  	input a,b;

  	wire y;
  	//assign y = (a & ~b) | (~a & b);
  	assign y =  a ^ b;
  	
endmodule

module dassign1_1 (y,a,b,c,d,e,f,g);
    output y;
    input a,b,c,d,e,f,g;
	
  	wire g1output, g2output, g3output, g4output, g5output;
  	
    nand3 gate1(g1output, a, b, c);
  	nand2 gate2(g2output, g1output, d);
  	nand2 gate3(g3output, f, g);
  	nor2 gate4(g4output, e, g3output);
    nor2 gate5(g5output, g2output, g4output);
    inverter gate6(y, g5output);
  
  
  	//wire y;
  
    //assign y = (a & b & c) | (~d) | (~e & f & g); 
    	
endmodule