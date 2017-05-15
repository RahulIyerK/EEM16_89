`timescale 1ns / 1ps
//

 module HW1_Proj4(


// Slide Switch Inputs 
	 input [2:0] sw, 
   
// LED Outputs
     output [0:0]led
 );


assign led[0] = (~sw[2] & sw[1] & sw[0]) | ~(sw[1] & ~sw[0]) | (sw[1] & sw[0]);

endmodule