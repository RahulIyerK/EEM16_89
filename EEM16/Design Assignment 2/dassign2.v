`timescale 1ns/100ps
/* 
  Notes:
    LSD is the least-significant digit
    MSD is the most-significant digit
  Algorithm:
    // get 10's complement for B when subtracting
    if (sub) ? 
       B=9-B (or B=10+~B), (Cin=1 for LSD only) : 
       B=B,   (Cin=0 for LSD only)
    // binary summation
    S=A+B+Cin
    // determine the BCD digit and Carry out of the digit
    BCD= (S<10) ? S : S-10 //check the Sum if it is more than 10
    Cout = (S<10) ? 0 : 1
    // overflow/underflow check 
      positive adding positive -result> negative
      negative adding negative -result> positive
      postive subtracting negative -result> negative
      negative subtracting positive -result> positive
    check for positive and negative of a decimal digit or number
      if (MSD < 5) ? // (check the bit[4] of MSD-5 if 0 then negative)
        positive 
      else
        negative 
  Some simple examples of negatives and subtractions
    0238-0111 (9889)= (LSD) 8+9=17 cout=1, 3+8+1=12 cout=1,	2+8+1=11 cout=1,(MSD) 0+9+1=10 cout=1
    	      => result=0127
    0238-0181 (9819)= (LSD) 8+9=17 cout=1, 3+1+1=5 cout=0,	2+8=10 cout=1,	(MSD) 0+9+1=10 cout=1  
     	      => result=0057
    0238-0881 (9119)= (LSD) 8+9=17 cout=1, 3+1+1=5 cout=0,	2+1=3 cout=0,	(MSD) 0+9=9 cout=0 
    	      => result=9357 (-643)
    0238+9881 (-119)= (LSD) 8+1=9 cout=0,  3+8=11 cout=1,	2+8+1=11 cout=1,(MSD) 0+9+1=10, cout=1 
    	      => result=0119
    0238+4881 = (LSD) 8+1=9 cout=0,	   3+8=11 cout=1,	2+8+1=11 cout=1,(MSD) 0+4+1=5, cout=0 
    	      => result=5119 (-4881) (overflow)
    0238+5881 (-4119)= (LSD) 8+1=9 cout=0, 3+8=11 cout=1,	2+8+1=11 cout=1,(MSD) 0+5+1=6, cout=0 
    	      => result=6119 (-3881) 
    5119+9100 (-900)= (LSD) 9+0=9 cout=0,  1+0=1 cout=0,	1+1=2 cout=0,	(MSD) 5+9=14, cout=1 
    	      => result=4219 (underflow)
*/
////////////////////////////////////////////////////////////////
//  module for add/subtract of a signal decimal digit
////////////////////////////////////////////////////////////////
module deciadd (digInA, digInB, sub, cin, digOut, cout);
////////////////////////////////////////////////////////////////
//  input/output declarations
////////////////////////////////////////////////////////////////
input   [dlen:0]   digInA, digInB;
input   sub, cin;
output  [dlen:0]  digOut;
output  cout;
////////////////////////////////////////////////////////////////
//  parameter declarations
////////////////////////////////////////////////////////////////
parameter dlen=3;

////////////////////////////////////////////////////////////////
//  reg & wire declarations
////////////////////////////////////////////////////////////////
reg [dlen:0] digOut;
reg cout;

  
reg [dlen:0] B_value;
reg [dlen+1:0] sum;
  
//
// implements the 10's complement BCD for each digit
//
  always @ (*)
    begin
      if (sub == 1) //if we are subtracting
        begin
          B_value = 10 + ~digInB; //the 10's complement of the digit
        end
      else
        begin
          B_value = digInB; //leave it alone, because it is addition
        end
      
      sum = digInA + B_value + cin; //we add the new value of digit B to digit A and the carry in value
      
      //now we need to convert back from binary to BCD
      if (sum >= 4'b1010)
        begin
          cout = 1; 
          digOut = sum + 4'b0110;
        end
      else 
        begin
          cout = 0;
          digOut = sum;
        end
    end
  
  //(sub == 1) ? (B_value = 4'b1001 - digInB, 
endmodule

module dassign2 (wdinA, wdinB, sub, wdout, ovunflow);
////////////////////////////////////////////////////////////////
//  input/output declarations
////////////////////////////////////////////////////////////////
input   [wlen:0]   wdinA;
input   [wlen:0]   wdinB;
input   sub;
output  [wlen:0]  wdout;
output  ovunflow;

////////////////////////////////////////////////////////////////
//  parameter declarations
////////////////////////////////////////////////////////////////
parameter wlen=15;
parameter dlen=3;
	
////////////////////////////////////////////////////////////////
//  reg & wire declarations
////////////////////////////////////////////////////////////////
reg   [wlen:0]   out;
wire [dlen:0] d1inA, d2inA, d3inA, d4inA;
wire [dlen:0] d1inB, d2inB, d3inB, d4inB;
wire [dlen:0] d1out, d2out, d3out, d4out;
wire cin;
wire cout1,cout2,cout3,cout4;

////////////////////////////////////////////////////////////////
//  Combinational Logic - do NOT change this 
//     *We may check these internal signals*
////////////////////////////////////////////////////////////////
assign {d4inA,d3inA,d2inA,d1inA} = wdinA;
assign {d4inB,d3inB,d2inB,d1inB} = wdinB;

assign wdout = {d4out,d3out,d2out,d1out};

deciadd dig1(d1inA, d1inB, sub, cin, d1out, cout1);
deciadd dig2(d2inA, d2inB, sub, cout1, d2out, cout2);
deciadd dig3(d3inA, d3inB, sub, cout2, d3out, cout3);
deciadd dig4(d4inA, d4inB, sub, cout3, d4out, cout4);

reg ovunflow;

//
// your code here to deal properly with subtraction and ovunflow
//
  
  assign cin = (sub == 1'b1) ? (1'b1) : (1'b0); //when we subtract, we carry in a 1'b1 in the LSD
  /*
  
  overflow/underflow check: 
  
      positive adding positive -result> negative
      negative adding negative -result> positive
      postive subtracting negative -result> negative
      negative subtracting positive -result> positive
    check for positive and negative of a decimal digit or number
      if (MSD < 5) ? // (check the bit[4] of MSD-5 if 0 then negative)
        positive 
      else
        negative 
        
  */
  
  always @ (*)
    begin 
      if ((d4inA < 4'b0101) && (d4inB < 4'b0101) && (sub == 1'b0) && (d4out >= 4'b0101)) //positive adding positive and result is negative
        begin
          ovunflow = 1'b1;
        end
      else if ((d4inA >= 4'b0101) && (d4inB >= 4'b0101) && (sub == 1'b0) && (d4out < 4'b0101)) //negative adding negative and result is positive
        begin
          ovunflow = 1'b1;
        end
      else if ((d4inA < 4'b0101) && (d4inB >= 4'b0101) && (sub == 1'b1) && (d4out >= 4'b0101)) //positive subtracting negative and result is negative
        begin
          ovunflow = 1'b1;
        end
      else if ((d4inA >= 4'b0101) && (d4inB < 4'b0101) && (sub == 1'b1) && (d4out < 4'b0101)) //negative subtracting positive and result is positive
        begin 
          ovunflow = 1'b1;
        end
      else
        begin
          ovunflow = 1'b0;
        end
      
    end
  
  

endmodule
