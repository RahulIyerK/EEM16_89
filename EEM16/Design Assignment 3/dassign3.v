`timescale 1ns / 1ps

module dassign3(
		input 	    char_vald,
		input [7:0] charcode_data,
		input [3:0] charlen_data,
		output 	    char_next, led_drv,
		input 	    reset, clock
		);



  parameter S_START = 3'b000;
  parameter S_LOAD = 3'b001;
  parameter S_NONSPACE = 3'b010;
  parameter S_SPACE  = 3'b011;
  parameter S_GOOD = 3'b100;
  
  reg[2:0] cur_st;
  reg[2:0] nxt_st;
  
  reg trigger_sc = 1'b0;


   // Outputs from modules       
   wire       shft_data, sym_done, led_drv; 
   wire [3:0] cntr_data; 

   reg 	      char_next, char_load, shft_cnt, sym_strt;



   code_reg codestore0(charcode_data, charlen_data, char_load, 
                       sym_done, cntr_data, shft_data, reset, clock);
   led_fsm ledfsm0(sym_strt, shft_data, led_drv, sym_done, 
                   reset, clock);
  
  
  wire space_done;
         
  space_counter space_counter0(trigger_sc, space_done, clock);
  

  //reg first_symbol;

  reg test;
  
  
  always @ (posedge clock)
    begin
      cur_st <= nxt_st;

    end
  
  always @ (*)
    begin
    if (reset)
      begin
        nxt_st = S_START;
        char_next = 1'b0;
      end
    else
      begin
        
        case (cur_st)
          S_START:
            begin

              if (char_vald == 1'b0)
                begin
                  char_load = 1'b0; //don't load into the shift register, because the data is not valid
            	  trigger_sc = 1'b0;      
                  sym_strt = 1'b0;
                  
                  //first_symbol = 1'b0;

                  nxt_st = S_START; //we're going to remain in this start cycle till the char_vald signal is asserted
                end
              
              if (char_vald == 1'b1)
                begin
                  char_load = 1'b1; //loads charcode_data and charlen_data into the shift register
                  char_next = 1'b0; //makes sure that the char_next signal is not asserted					                  
                  if (charlen_data > 4'b0000)
                    begin
                        trigger_sc = 1'b0;
                        //first_symbol = 1'b1;
                        nxt_st = S_LOAD;
                    end
                  else if (charlen_data == 4'b0000)
                    begin
                      trigger_sc = 1'b1;

                      //first_symbol = 1'b0;
                      nxt_st = S_SPACE;
                    end

                end

            end
		  S_LOAD:
            begin
              sym_strt = 1'b1;
              nxt_st = S_NONSPACE;
            end
          
          S_NONSPACE:
            begin
              
              char_load = 1'b0; //make sure the char_load signal is not asserted
              
              if (sym_done == 1'b1)
                begin
                  if (cntr_data == 4'b0001)
                    begin
                      nxt_st = S_GOOD;
                    end
                  
                  if (cntr_data > 4'b0001)
                    begin
                      nxt_st = S_NONSPACE;
                      sym_strt = 1'b1;
                    end
                end
              else if (sym_done == 1'b0)
                begin
                  nxt_st = S_NONSPACE;
                  sym_strt = 1'b0;
                  
                end
              


            end
		S_SPACE:
          begin
            trigger_sc = 1'b0;
            
            char_load = 1'b0;


            if (space_done == 1'b1)
            begin
              nxt_st = S_GOOD;

            end
          
            if (space_done == 1'b0)
            begin 
              nxt_st = S_SPACE;
            end
            
        end
          
          S_GOOD:
            begin
              char_next = 1'b1;
              nxt_st = S_START;
            end
          
          default:
            begin
            end
        endcase
      end
    end  
  
  
endmodule // dassign3
