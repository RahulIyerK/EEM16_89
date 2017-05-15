module DesignTask3(	 
// Slide Switch Inputs 
	 input [3:0] sw, 
   
// LED Outputs
     output [0:0] led
 );

reg [0:0] led; //the output led
wire [3:0] sw; //the input 4 bits

always @(sw)
begin
	case(sw)	
	       4'b0011, 4'b0110, 4'b0111, 4'b1001, 4'b1010, 4'b1011:
         	led[0] = 1;
       default:
         	led[0] = 0;
	endcase
end

endmodule