module space_counter(
input set, 
output space_done,
input clock);

reg[3:0] cntr = 4'b0000;
  
reg space_done;

reg acting = 1'b0;

reg[3:0] cntr_oldval;

  always @(posedge clock) begin
    
    if (set == 1'b1)
      begin
        cntr <= 4'b0100;
        space_done <= 1'b0;
        acting = 1'b1;
      end
    else //set == 1'b0;
      begin
        if (cntr == 4'b0000 && acting == 1'b1)
          begin
            space_done <= 1'b1;
            acting = 1'b0;
          end
        else 
          begin
            cntr <= cntr - 1;
            space_done <= 1'b0;
            acting = 1'b1;
          end
        
        
        
        
      end

  end

endmodule