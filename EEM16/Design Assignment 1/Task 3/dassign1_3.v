`timescale 1ns / 1ps
// EEM16 - Logic Design
// Design Assignment #1 - Problem #3
// dassign1_3.v
module dassign1_3(y,x);
   output y;
   input [3:0] x;
  
  wire [3:0] x;
  //reg a,b,c,d;
  reg y;

   
   always @(x)
   begin
     
     case (x)
       4'b0011, 4'b0110, 4'b0111, 4'b1001, 4'b1010, 4'b1011:
         y = 1;
       default:
         y = 0;
     endcase
     //a = (4'b1000 & x) >> 3; //x[3]
     //b = (4'b0100 & x) >> 2; //x[2]
     //c = (4'b0010 & x) >> 1; //x[1]
     //d = (4'b0001 & x); //x[0]
     
    //y = (~a & c & d) | (~a & b & c) | (a & ~b & d) | (a & ~b & c);
   end
  
endmodule