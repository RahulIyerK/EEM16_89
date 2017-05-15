`timescale 1ns / 1ps
// EEM16 - Logic Design
// Design Assignment #1 - Problem #2
// dassign1_2.v
module dassign1_2 (y,z,a,b,c,d,e);
    output y,z;
    input a,b,c,d,e;
// your code here
    wire y;
  	wire z;

  assign y = (~a & b & c) | ~(b & ~c) | (b & c);
   
  //assign y = (~b | c);
  
  assign z = (a & b & ~c) | ~(a & ~(~b & c)) | ~(~d | e) & c;
  
  //assign z = (~a) | (b & ~c) | (~b & c) | (d & ~e & c);
endmodule