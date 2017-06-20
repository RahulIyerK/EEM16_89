module code_reg(
		input [7:0]  charcode_data,
		input [3:0]  charlen_data,
		input 	     char_load, shft_cnt,
		output [3:0] cntr_data, 
		output 	     shft_data,
		input 	     reset, clock
		 );

   reg [7:0] 	     shftr_o, shftr_i;
   reg [3:0] 	     cntr_o, cntr_i;

   always @(posedge clock) begin
      shftr_o <= shftr_i;
      cntr_o <= cntr_i;
   end

   wire		     shft_data;
   wire [3:0] 	     cntr_data;

   always @(*) begin
      if (reset) begin
	 shftr_i = 8'b00000000;
         cntr_i = 4'b0000;
      end
      else begin
	 if (char_load) begin //load overwrites any shifting or counting
	    shftr_i = charcode_data;
        cntr_i = charlen_data;
	 end
	 else begin //shift MSB 
	    if (shft_cnt) begin //shift to MSB and count down by 1
	      shftr_i = shftr_o << 1;
          cntr_i = cntr_o - 1;
	    end
	    else begin //no shift or count (keep the previous data)
	       shftr_i = shftr_o;
           cntr_i = cntr_o;
	    end
	 end // else: !if(char_load)
      end // else: !if(reset)
   end // always @ (reset or char_load or shft_cnt)

   assign cntr_data = cntr_o;
   assign shft_data = shftr_o[7];
   
endmodule // code_reg


