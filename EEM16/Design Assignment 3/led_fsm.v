////////////////////////////////////////////////////////////////
//  module LED FSM 
////////////////////////////////////////////////////////////////
module led_fsm(
	       input  sym_strt, symbol,
	       output led_drv, sym_done,
	       input  reset, clock
	       );
////////////////////////////////////////////////////////////////
//  parameter declarations
////////////////////////////////////////////////////////////////
   parameter START=3'b000;
  parameter DOT0 = 3'b001;
  parameter DASH0 = 3'b010;
  parameter DASH1 = 3'b011;
  parameter DASH2 = 3'b100;
   //declare each state name as a parameter

////////////////////////////////////////////////////////////////
//  State register for FSM
////////////////////////////////////////////////////////////////
   reg [2:0] 	     led_st;
 
   always @(posedge clock) begin
      led_st <= led_nx_st;
   end


////////////////////////////////////////////////////////////////
//  State and Output logic for statemachine
////////////////////////////////////////////////////////////////
   reg [2:0]  led_nx_st;
   reg 	      led_drv, sym_done; //outputs you need to generate
   
   always @(*) begin
      if (reset) begin
	 led_nx_st = START;
      end
      else begin
	 case (led_st)
	   START: 
         begin
           
           if (!sym_strt && led_nx_st !=DASH0 && led_nx_st !=DOT0)
             begin
               led_drv = 1'b0;
               sym_done = 1'b0;
               
               led_nx_st = START; //remain in the start state
             end
           
           else if (sym_strt)
             begin
               led_drv = 1'b1;
               sym_done = 1'b0;

               if (symbol)
                 begin
                   led_nx_st = DASH0; //first dash state
                 end
               else if (!symbol)
                 begin
                   led_nx_st = DOT0; //dot state
                 end
           end
         
         end //end of START
       DASH0:
         begin
           led_drv = 1'b1;
           sym_done = 1'b0;
           led_nx_st = DASH1;
         end
       DASH1:
         begin
           led_drv = 1'b1;
           sym_done = 1'b0;
           led_nx_st = DASH2;
         end
       DASH2:
         begin
           led_drv = 1'b0;
           sym_done = 1'b1;
           led_nx_st = START;
         end
       DOT0:
         begin
           led_drv = 1'b0;
           sym_done = 1'b1;
           led_nx_st = START;
         end
	   default: begin
	      
	   end
	 endcase // case (led_st)
      end // else: !if(reset)
   end // always @ (*)
endmodule // led_fsm
