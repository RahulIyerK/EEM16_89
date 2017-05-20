module deciadd (digInA, digInB, sub, cin, digOut, cout);
////////////////////////////////////////////////////////////////
//  input/output declarations
////////////////////////////////////////////////////////////////
input   [3:0]   digInA, digInB;

input   sub, cin;

output  [3:0]  digOut;
reg [3:0] digOut;

output  cout;
reg cout;


reg [3:0] B_value;
reg [4:0] sum;

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

endmodule



