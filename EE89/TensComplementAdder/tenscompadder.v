module tenscomplementadder(

//CLK Input
	 input clk,

//Push Button Inputs
  input btnC, //clear
	 input btnU, //addition
	 input btnD, //subtraction
	 input btnR, //load dinB
	 input btnL, //load dinA

// Slide Switch Inputs
	 input [15:0] sw, //set dinA[15:0] and dinB[15:0]

// LED Outputs
     output [15:0] led,

// Seven Segment Display Outputs
     output [6:0] seg,
     output [3:0] an,
     output dp
 );

//Seven Segment Display Signal

reg [15:0] x;//input to seg7 to define segment pattern
wire [15:0] led;

reg[3:0] d1inA, d2inA, d3inA, d4inA;
reg[3:0] d1inB, d2inB, d3inB, d4inB;

wire[3:0] d1out, d2out, d3out, d4out;
wire[3:0] d1_c, d2_c, d3_c, d4_c;

reg sub;
reg ovunflow;
deciadd d1add(d1inA, d1inB, sub, sub, d1out, d1_c);
deciadd d2add(d2inA, d2inB, sub, d1_c, d2out, d2_c);
deciadd d3add(d3inA, d3inB, sub, d2_c, d3out, d3_c);
deciadd d4add(d4inA, d4inB, sub, d3_c, d4out, d4_c);

// 7segment display module

seg7decimal u7 (

.x(x),
.clk(clk),
.clr(btnC),
.a_to_g(seg),
.an(an),
.dp(dp)
);

assign led[0] = ovunflow;

always @ (posedge clk)
  begin

  	if (btnL == 1)
  	begin
      d4inA = sw[15:12]; //MSD for digInA
      d3inA = sw[11:8];
      d2inA = sw[7:4];
      d1inA = sw[3:0]; //LSD for digInA

  	end

  	if (btnR == 1)
  	begin
      d4inB = sw[15:12]; //MSD for digInA
      d3inB = sw[11:8];
      d2inB = sw[7:4];
      d1inB = sw[3:0]; //LSD for digInA

  	end

    if (btnU == 1)
    begin
      sub = 1'b0; //addition
    end

    if (btnD == 1)
    begin
      sub = 1'b1; //subtraction
    end
    
    if (btnU == 0 && btnD == 0)
    begin
        x[15:12] = 4'b0000;
        x[11:8] = 4'b0000;
        x[7:4] = 4'b0000;
        x[3:0] = 4'b0000;
        
        ovunflow = 1'b0;
    end
    else
    begin
        x[15:12] = d4out;
        x[11:8] = d3out;
        x[7:4] = d2out;
        x[3:0] = d1out;
        
        
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
    
    
    

  end

endmodule
